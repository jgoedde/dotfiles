#!/bin/bash

WALLS_DIR="$HOME/Pictures/walls"

WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)

[ -z "$WALLPAPER" ] && exit 1

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"

matugen image "$WALLPAPER" -m dark -q --source-color-index 0 --type scheme-expressive

POST_SCRIPT="$HOME/.local/bin/wallpaper-post.sh"
[ -x "$POST_SCRIPT" ] && "$POST_SCRIPT" "$WALLPAPER"
