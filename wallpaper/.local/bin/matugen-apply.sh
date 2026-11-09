#!/bin/bash
# Render the own matugen templates (~/.config/matugen/config.toml) for a wallpaper,
# matching the light/dark mode, scheme and contrast currently set in DMS.
#
# Usage: matugen-apply.sh [--if-mode-changed] [WALLPAPER]
#   WALLPAPER          defaults to the wallpaper currently shown by DMS
#   --if-mode-changed  only run when the DMS light/dark mode differs from the last run
#                      (used by matugen-mode-sync.path on DMS session changes)

IF_MODE_CHANGED=0
if [ "${1:-}" = "--if-mode-changed" ]; then
	IF_MODE_CHANGED=1
	shift
fi

DMS_SESSION="${XDG_STATE_HOME:-$HOME/.local/state}/dms/session.json"
DMS_SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/dms/settings.json"
MODE_STAMP="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/last-mode"

MODE=dark
if [ "$(jq -r '.isLightMode // false' "$DMS_SESSION" 2>/dev/null)" = "true" ]; then
	MODE=light
fi

if [ "$IF_MODE_CHANGED" = 1 ] && [ "$(cat "$MODE_STAMP" 2>/dev/null)" = "$MODE" ]; then
	exit 0
fi

WALLPAPER="${1:-}"
if [ -z "$WALLPAPER" ] && command -v dms >/dev/null 2>&1; then
	WALLPAPER=$(dms ipc call wallpaper get 2>/dev/null)
fi
[ -f "$WALLPAPER" ] || { echo "matugen-apply: no wallpaper found" >&2; exit 1; }

# Keep scheme and contrast in sync with what DMS renders, so both runs produce the same colors
SCHEME=$(jq -r '.matugenScheme // "scheme-tonal-spot"' "$DMS_SETTINGS" 2>/dev/null || echo scheme-tonal-spot)
CONTRAST=$(jq -r '.matugenContrast // 0' "$DMS_SETTINGS" 2>/dev/null || echo 0)

# DMS renders the user templates but not their post_hooks (cursor, bat cache, btop, ...),
# so run matugen ourselves.
# matugen 4 requires a [config] table; config.toml stays without one because DMS merges
# it into its own config (which already has [config]), so prepend it to a temp copy.
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
TMP_CONFIG=$(mktemp --suffix=.toml)
trap 'rm -f "$TMP_CONFIG"' EXIT
{ printf '[config]\n\n'; cat "$MATUGEN_CONFIG"; } > "$TMP_CONFIG"
matugen image "$WALLPAPER" -c "$TMP_CONFIG" -m "$MODE" -t "$SCHEME" --contrast "$CONTRAST" \
	-q --source-color-index 0 || exit 1

mkdir -p "$(dirname "$MODE_STAMP")"
echo "$MODE" > "$MODE_STAMP"

POST_SCRIPT="$HOME/.local/bin/wallpaper-post.sh"
[ -x "$POST_SCRIPT" ] && "$POST_SCRIPT" "$WALLPAPER"

exit 0
