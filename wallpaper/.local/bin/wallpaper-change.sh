#!/bin/bash

WALLS_DIR="$HOME/Pictures/walls"

WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)

[ -z "$WALLPAPER" ] && exit 1

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"

wal -i "$WALLPAPER" -q --backend wal

cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/colors-kitty.conf

kill -SIGUSR1 $(pgrep -x kitty) 2>/dev/null

exit 0
