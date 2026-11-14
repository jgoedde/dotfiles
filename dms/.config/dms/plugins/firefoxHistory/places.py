#!/usr/bin/env python3
"""Dump the most-used Firefox history entries as JSON for the DMS launcher.

Firefox keeps places.sqlite / favicons.sqlite locked and writes recent changes to the
-wal files, so they are copied to a temp dir and read from there.

Favicons are written to $XDG_CACHE_HOME/dms-firefox-history/favicons/ (named by content
hash, so unchanged icons are not rewritten) and referenced per entry. An entry gets the
icon stored for its exact page, else the best icon seen for its host.

Usage: places.py [profile-dir] [limit]
Without a profile dir, the default profile is taken from installs.ini (falling back to
the Default=1 entry in profiles.ini).
"""
import configparser
import hashlib
import json
import os
import shutil
import sqlite3
import sys
import tempfile
from pathlib import Path
from urllib.parse import urlsplit

FIREFOX_ROOTS = [Path.home() / ".config/mozilla/firefox", Path.home() / ".mozilla/firefox"]
CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "dms-firefox-history" / "favicons"
SVG_WIDTH = 65535  # Firefox stores vector icons with this width
WANTED_WIDTH = 32

QUERY = """
SELECT p.url, COALESCE(NULLIF(p.title, ''), p.url) AS title
FROM moz_places p
WHERE p.url LIKE 'http%' AND p.hidden = 0 AND p.visit_count > 0
ORDER BY p.frecency DESC
LIMIT ?
"""

ICON_QUERY = """
SELECT pg.page_url, i.icon_url, i.width, i.data
FROM moz_icons i
LEFT JOIN moz_icons_to_pages ip ON ip.icon_id = i.id
LEFT JOIN moz_pages_w_icons pg ON pg.id = ip.page_id
WHERE i.data IS NOT NULL
"""


def default_profile() -> Path | None:
    for root in FIREFOX_ROOTS:
        ini = configparser.ConfigParser()
        ini.read(root / "installs.ini")
        for section in ini.sections():
            if path := ini[section].get("Default"):
                return root / path
        ini = configparser.ConfigParser()
        ini.read(root / "profiles.ini")
        for section in ini.sections():
            if ini[section].get("Default") == "1" and (path := ini[section].get("Path")):
                relative = ini[section].get("IsRelative", "1") == "1"
                return root / path if relative else Path(path)
    return None


def copy_db(profile: Path, name: str, tmp: str) -> Path | None:
    if not (profile / name).exists():
        return None
    for suffix in ("", "-wal"):
        if (profile / (name + suffix)).exists():
            shutil.copy2(profile / (name + suffix), Path(tmp) / (name + suffix))
    return Path(tmp) / name


def icon_rank(width: int) -> int:
    """Lower is better: smallest bitmap >= 32px, then SVG, then the largest smaller bitmap.

    SVG favicons often switch colors via prefers-color-scheme, which Qt ignores, so e.g.
    GitHub's renders dark-on-dark; bitmaps are the safer pick.
    """
    if width == SVG_WIDTH:
        return 5_000
    return width - WANTED_WIDTH if width >= WANTED_WIDTH else 10_000 - width


def host(url: str | None) -> str:
    try:
        return (urlsplit(url).hostname or "").removeprefix("www.") if url else ""
    except ValueError:
        return ""


def write_icon(data: bytes) -> str:
    ext = "svg" if data.lstrip()[:5] in (b"<svg ", b"<?xml") else "png"
    path = CACHE_DIR / f"{hashlib.sha1(data).hexdigest()[:20]}.{ext}"
    if not path.exists():
        path.write_bytes(data)
    return str(path)


def load_icons(db: Path) -> tuple[dict, dict]:
    """Return (page_url -> icon path, host -> icon path)."""
    best_page: dict[str, tuple[int, bytes]] = {}
    best_host: dict[str, tuple[int, bytes]] = {}
    con = sqlite3.connect(db)
    try:
        for page_url, icon_url, width, data in con.execute(ICON_QUERY):
            rank = icon_rank(width)
            if page_url and (page_url not in best_page or rank < best_page[page_url][0]):
                best_page[page_url] = (rank, data)
            h = host(page_url) or host(icon_url.removeprefix("fake-favicon-uri:"))
            if h and (h not in best_host or rank < best_host[h][0]):
                best_host[h] = (rank, data)
    finally:
        con.close()

    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    written: dict[bytes, str] = {}

    def path_for(data: bytes) -> str:
        if data not in written:
            written[data] = write_icon(data)
        return written[data]

    icons = ({u: path_for(d) for u, (_, d) in best_page.items()},
             {h: path_for(d) for h, (_, d) in best_host.items()})
    used = set(written.values())
    for stale in CACHE_DIR.iterdir():
        if str(stale) not in used:
            stale.unlink(missing_ok=True)
    return icons


def main() -> None:
    profile = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 and sys.argv[1] else default_profile()
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 5000
    if profile is None or not (profile / "places.sqlite").exists():
        sys.exit(f"places.sqlite not found (profile: {profile})")

    with tempfile.TemporaryDirectory() as tmp:
        con = sqlite3.connect(copy_db(profile, "places.sqlite", tmp))
        try:
            rows = con.execute(QUERY, (limit,)).fetchall()
        finally:
            con.close()
        page_icons, host_icons = {}, {}
        if favicons := copy_db(profile, "favicons.sqlite", tmp):
            try:
                page_icons, host_icons = load_icons(favicons)
            except (sqlite3.Error, OSError) as err:
                print(f"favicons skipped: {err}", file=sys.stderr)

    out = []
    for u, t in rows:
        entry = {"u": u, "t": t}
        if icon := page_icons.get(u) or host_icons.get(host(u)):
            entry["i"] = icon
        out.append(entry)
    json.dump(out, sys.stdout, ensure_ascii=False)


if __name__ == "__main__":
    main()
