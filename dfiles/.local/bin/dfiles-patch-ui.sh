#!/bin/bash
# Workaround: dfiles' UI never loads on Debian 13 (Qt 6.8.2) and dies with
# "Failed to load configuration". The QML types form a cycle
#   FilesPane -> RecentView/SearchResults/TrashView -> ListingView -> FilesPane
# (ListingView declares `required property FilesPane host`) and Qt 6.8's
# type loader hangs on it. This script extracts the UI that is embedded in the
# installed dfiles, breaks the cycle, and stores it where DFILES_SHELL_DIR
# (set in environment.d) points.
#
# Runs at login via dfiles-patch-ui.service. It only re-extracts when the
# dfiles version has changed. After an apt upgrade, run it by hand
# (`dfiles kill` first, so the extraction run doesn't collide with a live
# instance). Remove this package once upstream no longer has the cycle.

set -euo pipefail

DEST="${XDG_DATA_HOME:-$HOME/.local/share}/dfiles-ui"
VERSION=$(dfiles version)

if [[ "${1:-}" != "--force" && -f "$DEST/.dfiles-version" && "$(<"$DEST/.dfiles-version")" == "$VERSION" ]]; then
	exit 0
fi

# dfiles unpacks its embedded UI to $XDG_RUNTIME_DIR/dfiles-shell/<hash> on
# every run and logs that path. Run it once without our override to learn it.
# On Qt 6.8 the UI exits immediately; if it ever starts fine, the timeout ends it.
LOG=$(timeout 15 env -u DFILES_SHELL_DIR dfiles run --hidden 2>&1 || true)
SRC=$(grep -oP 'starting UI \(config=\K[^)]+' <<<"$LOG" | tail -n1)

if [[ -z "$SRC" || ! -f "$SRC/shell.qml" ]]; then
	echo "dfiles-patch-ui: could not find the extracted UI (is dfiles already running? try 'dfiles kill')" >&2
	exit 1
fi

TMP="$DEST.tmp"
rm -rf "$TMP"
cp -r "$SRC" "$TMP"
chmod -R u+w "$TMP"

LISTING="$TMP/Modules/ListingView.qml"
if grep -q 'required property FilesPane host' "$LISTING"; then
	sed -i 's/required property FilesPane host/required property Item host/' "$LISTING"
else
	echo "dfiles-patch-ui: the cycle is gone in $VERSION, so this workaround can probably be removed" >&2
fi

echo "$VERSION" >"$TMP/.dfiles-version"
rm -rf "$DEST"
mv "$TMP" "$DEST"
echo "dfiles-patch-ui: patched UI for $VERSION -> $DEST"
