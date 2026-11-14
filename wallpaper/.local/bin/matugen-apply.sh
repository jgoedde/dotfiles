#!/bin/bash
# Render the own matugen templates (~/.config/matugen/config.toml plus config.d/*.toml)
# for a wallpaper, matching the light/dark mode, scheme and contrast currently set in DMS
# (without DMS: dark mode, scheme-content).
#
# Usage: matugen-apply.sh [--if-changed] [WALLPAPER]
#   WALLPAPER     defaults to the wallpaper currently shown by DMS
#   --if-changed  only run when the wallpaper or the DMS light/dark mode differs from
#                 the last run (used by matugen-sync.path on DMS session changes)

IF_CHANGED=0
if [ "${1:-}" = "--if-changed" ]; then
	IF_CHANGED=1
	shift
fi

DMS_SESSION="${XDG_STATE_HOME:-$HOME/.local/state}/dms/session.json"
DMS_SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/dms/settings.json"
# Records the mode and wallpaper of the last successful run, one per line
LAST_APPLY="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/last-apply"

MODE=dark
if [ "$(jq -r '.isLightMode // false' "$DMS_SESSION" 2>/dev/null)" = "true" ]; then
	MODE=light
fi

WALLPAPER="${1:-}"
if [ -z "$WALLPAPER" ] && command -v dms >/dev/null 2>&1; then
	WALLPAPER=$(dms ipc call wallpaper get 2>/dev/null)
fi
[ -f "$WALLPAPER" ] || { echo "matugen-apply: no wallpaper found" >&2; exit 1; }

APPLY_STATE=$(printf '%s\n%s' "$MODE" "$WALLPAPER")
if [ "$IF_CHANGED" = 1 ] && [ "$(cat "$LAST_APPLY" 2>/dev/null)" = "$APPLY_STATE" ]; then
	exit 0
fi

# Keep scheme and contrast in sync with what DMS renders, so both runs produce the same colors.
# Without DMS (GNOME), use the content scheme GNOME was themed with before.
SCHEME=scheme-content
CONTRAST=0
if [ -f "$DMS_SETTINGS" ]; then
	SCHEME=$(jq -r '.matugenScheme // "scheme-tonal-spot"' "$DMS_SETTINGS" 2>/dev/null || echo scheme-tonal-spot)
	CONTRAST=$(jq -r '.matugenContrast // 0' "$DMS_SETTINGS" 2>/dev/null || echo 0)
fi

# DMS renders the user templates but not their post_hooks (cursor, bat cache, btop, ...),
# so run matugen ourselves.
# The run config is the global [config] table, the shared templates (config.toml) and any
# package fragments (config.d/*.toml, e.g. GNOME's gtk/albert/cursor from matugen-gnome).
# matugen 4 requires a [config] table; config.toml stays without one because DMS merges
# it into its own config (which already has [config]). DMS reads only config.toml.
MATUGEN_DIR="$HOME/.config/matugen"
TMP_CONFIG=$(mktemp --suffix=.toml)
trap 'rm -f "$TMP_CONFIG"' EXIT
{
	printf '[config]\n\n'
	cat "$MATUGEN_DIR/config.toml"
	for fragment in "$MATUGEN_DIR"/config.d/*.toml; do
		[ -f "$fragment" ] && printf '\n' && cat "$fragment"
	done
} > "$TMP_CONFIG"
matugen image "$WALLPAPER" -c "$TMP_CONFIG" -m "$MODE" -t "$SCHEME" --contrast "$CONTRAST" \
	-q --source-color-index 0 || exit 1

mkdir -p "$(dirname "$LAST_APPLY")"
printf '%s\n' "$APPLY_STATE" > "$LAST_APPLY"

POST_SCRIPT="$HOME/.local/bin/wallpaper-post.sh"
[ -x "$POST_SCRIPT" ] && "$POST_SCRIPT" "$WALLPAPER"

exit 0
