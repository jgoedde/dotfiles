#!/bin/bash

WALLS_DIR="$HOME/Pictures/walls"

WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)

[ -z "$WALLPAPER" ] && exit 1

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"

gnome_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)
[[ "$gnome_scheme" == "'prefer-dark'" ]] && matugen_mode="dark" || matugen_mode="light"

matugen image "$WALLPAPER" -m "$matugen_mode" -q --source-color-index 0
