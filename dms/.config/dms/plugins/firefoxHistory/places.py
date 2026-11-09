#!/usr/bin/env python3
"""Dump the most-used Firefox history entries as JSON for the DMS launcher.

Firefox keeps places.sqlite locked and writes recent visits to the -wal file, so both
are copied to a temp dir and read from there.

Usage: places.py [profile-dir] [limit]
Without a profile dir, the default profile is taken from installs.ini (falling back to
the Default=1 entry in profiles.ini).
"""
import configparser
import json
import shutil
import sqlite3
import sys
import tempfile
from pathlib import Path

FIREFOX_ROOTS = [Path.home() / ".config/mozilla/firefox", Path.home() / ".mozilla/firefox"]

QUERY = """
SELECT p.url, COALESCE(NULLIF(p.title, ''), p.url) AS title
FROM moz_places p
WHERE p.url LIKE 'http%' AND p.hidden = 0 AND p.visit_count > 0
ORDER BY p.frecency DESC
LIMIT ?
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


def main() -> None:
    profile = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 and sys.argv[1] else default_profile()
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 5000
    if profile is None or not (profile / "places.sqlite").exists():
        sys.exit(f"places.sqlite not found (profile: {profile})")

    with tempfile.TemporaryDirectory() as tmp:
        for name in ("places.sqlite", "places.sqlite-wal"):
            if (profile / name).exists():
                shutil.copy2(profile / name, Path(tmp) / name)
        con = sqlite3.connect(Path(tmp) / "places.sqlite")
        try:
            rows = con.execute(QUERY, (limit,)).fetchall()
        finally:
            con.close()

    json.dump([{"u": u, "t": t} for u, t in rows], sys.stdout, ensure_ascii=False)


if __name__ == "__main__":
    main()
