#!/bin/bash
# Switch to a random wallpaper and re-theme everything via matugen.
# Used by the niri Mod+Ctrl+W binding and the GNOME Super+Ctrl+W shortcut.

PICTURES_DIR=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
WALLS_DIR="${WALLS_DIR:-$PICTURES_DIR/Walls}"

if command -v dms >/dev/null 2>&1 && dms ipc call wallpaper get >/dev/null 2>&1; then
	CURRENT=$(dms ipc call wallpaper get)
	HAS_DMS=1
elif command -v gsettings >/dev/null 2>&1; then
	CURRENT=$(gsettings get org.gnome.desktop.background picture-uri 2>/dev/null | sed "s|^'file://||; s|'$||")
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

# Re-theme the own matugen templates for the new wallpaper (honours DMS light/dark mode)
"$HOME/.local/bin/matugen-apply.sh" "$WALLPAPER"
