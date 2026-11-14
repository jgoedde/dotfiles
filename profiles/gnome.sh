#!/usr/bin/env bash
# Setup steps for the gnome profile. Run by install.sh after common.sh.
set -e

gsettings set org.gnome.desktop.default-applications.terminal exec ghostty

# Super+Ctrl+W: random wallpaper and re-theme (same script as niri's Mod+Ctrl+W).
# Custom shortcuts live under their own dconf path; add ours to the list only once.
MEDIA_KEYS=org.gnome.settings-daemon.plugins.media-keys
SHORTCUT=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dotfiles-wallpaper-change/
existing_bindings=$(gsettings get "$MEDIA_KEYS" custom-keybindings)
case "$existing_bindings" in
*"'$SHORTCUT'"*) ;;
"@as []" | "[]") gsettings set "$MEDIA_KEYS" custom-keybindings "['$SHORTCUT']" ;;
*) gsettings set "$MEDIA_KEYS" custom-keybindings "${existing_bindings%]}, '$SHORTCUT']" ;;
esac
BINDING="$MEDIA_KEYS.custom-keybinding:$SHORTCUT"
gsettings set "$BINDING" name "Random wallpaper"
gsettings set "$BINDING" command "$HOME/.local/bin/wallpaper-change.sh"
gsettings set "$BINDING" binding "<Super><Control>w"
