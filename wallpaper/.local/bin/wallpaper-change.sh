#!/bin/bash
# Switch to a random wallpaper and re-theme everything via matugen.
# Used by the niri Mod+Ctrl+W binding and the GNOME Super+Ctrl+W shortcut.
# The Profile's desktop adapter gets and sets the wallpaper.

ADAPTER="$HOME/.local/bin/desktop-adapter"
[ -x "$ADAPTER" ] || { echo "wallpaper-change: desktop adapter missing: $ADAPTER" >&2; exit 1; }

PICTURES_DIR=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
WALLS_DIR="${WALLS_DIR:-$PICTURES_DIR/Walls}"

CURRENT=$("$ADAPTER" wallpaper 2>/dev/null)

# Random image, never the current one
WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
	grep -vxF "${CURRENT:-}" | shuf -n1)

[ -z "$WALLPAPER" ] && exit 1

"$ADAPTER" set-wallpaper "$WALLPAPER" || exit 1

# Re-theme the own matugen templates for the new wallpaper
"$HOME/.local/bin/matugen-apply.sh" "$WALLPAPER"
