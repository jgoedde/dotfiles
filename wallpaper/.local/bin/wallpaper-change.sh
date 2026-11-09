#!/bin/bash
# Switch to a random wallpaper and re-theme everything via matugen.
# Used by the systemd timer and the niri Mod+Ctrl+W binding.

PICTURES_DIR=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
WALLS_DIR="${WALLS_DIR:-$PICTURES_DIR/Walls}"

if command -v dms >/dev/null 2>&1 && dms ipc call wallpaper get >/dev/null 2>&1; then
	CURRENT=$(dms ipc call wallpaper get)
	HAS_DMS=1
fi

# Random image, never the current one
WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
	grep -vxF "${CURRENT:-}" | shuf -n1)

[ -z "$WALLPAPER" ] && exit 1

if [ -n "$HAS_DMS" ]; then
	# DMS draws the wallpaper (and its own shell/niri colors)
	dms ipc call wallpaper set "$WALLPAPER"
else
	gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi

# DMS renders the user templates but not their post_hooks (cursor, bat cache, btop, ...),
# so run matugen ourselves.
# matugen 4 requires a [config] table; config.toml stays without one because DMS merges
# it into its own config (which already has [config]), so prepend it to a temp copy.
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
TMP_CONFIG=$(mktemp --suffix=.toml)
trap 'rm -f "$TMP_CONFIG"' EXIT
{ printf '[config]\n\n'; cat "$MATUGEN_CONFIG"; } > "$TMP_CONFIG"
matugen image "$WALLPAPER" -c "$TMP_CONFIG" -m dark -q --source-color-index 0

POST_SCRIPT="$HOME/.local/bin/wallpaper-post.sh"
[ -x "$POST_SCRIPT" ] && "$POST_SCRIPT" "$WALLPAPER"

exit 0
