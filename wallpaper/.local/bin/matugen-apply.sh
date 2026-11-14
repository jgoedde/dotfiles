#!/bin/bash
# Render the own matugen templates (~/.config/matugen/config.toml plus config.d/*.toml)
# for a wallpaper, matching the light/dark mode, scheme and contrast reported by the
# Profile's desktop adapter (~/.local/bin/desktop-adapter).
#
# Usage: matugen-apply.sh [--if-changed] [WALLPAPER]
#   WALLPAPER     defaults to the current wallpaper (from the desktop adapter)
#   --if-changed  only run when the wallpaper or the light/dark mode differs from
#                 the last run (used by watchers that fire on desktop changes)

IF_CHANGED=0
if [ "${1:-}" = "--if-changed" ]; then
	IF_CHANGED=1
	shift
fi

ADAPTER="$HOME/.local/bin/desktop-adapter"
[ -x "$ADAPTER" ] || { echo "matugen-apply: desktop adapter missing: $ADAPTER" >&2; exit 1; }

# Records the mode and wallpaper of the last successful run, one per line
LAST_APPLY="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/last-apply"

MODE=$("$ADAPTER" mode) || exit 1

WALLPAPER="${1:-}"
[ -n "$WALLPAPER" ] || WALLPAPER=$("$ADAPTER" wallpaper)
[ -f "$WALLPAPER" ] || { echo "matugen-apply: no wallpaper found" >&2; exit 1; }

APPLY_STATE=$(printf '%s\n%s' "$MODE" "$WALLPAPER")
if [ "$IF_CHANGED" = 1 ] && [ "$(cat "$LAST_APPLY" 2>/dev/null)" = "$APPLY_STATE" ]; then
	exit 0
fi

# Same scheme and contrast the desktop renders with, so both runs produce the same colors.
SCHEME=$("$ADAPTER" scheme) || exit 1
CONTRAST=$("$ADAPTER" contrast) || exit 1

# Run matugen ourselves so every template renders and its post_hooks (bat cache, btop,
# ...) run, whatever the desktop does on its own.
# The run config is the global [config] table, the shared templates (config.toml) and any
# package fragments (config.d/*.toml, e.g. gtk/albert from matugen-gnome).
# matugen 4 requires a [config] table; config.toml stays without one because a desktop
# shell may merge it into its own config (DMS does, and reads only config.toml).
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

# Let the desktop's own UI pick up the new theme
"$ADAPTER" reload || echo "matugen-apply: warning: desktop adapter reload failed" >&2

POST_SCRIPT="$HOME/.local/bin/wallpaper-post.sh"
[ -x "$POST_SCRIPT" ] && "$POST_SCRIPT" "$WALLPAPER"

exit 0
