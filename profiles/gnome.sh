#!/usr/bin/env bash
# Setup steps for the gnome profile. Run by install.sh after common.sh.
set -e

gsettings set org.gnome.desktop.default-applications.terminal exec ghostty

# Custom shortcuts live under their own dconf path; add each to the list only once.
MEDIA_KEYS=org.gnome.settings-daemon.plugins.media-keys

# add_shortcut <id> <name> <command> <binding>
add_shortcut() {
	local shortcut="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$1/"
	local existing_bindings
	existing_bindings=$(gsettings get "$MEDIA_KEYS" custom-keybindings)
	case "$existing_bindings" in
	*"'$shortcut'"*) ;;
	"@as []" | "[]") gsettings set "$MEDIA_KEYS" custom-keybindings "['$shortcut']" ;;
	*) gsettings set "$MEDIA_KEYS" custom-keybindings "${existing_bindings%]}, '$shortcut']" ;;
	esac
	local binding="$MEDIA_KEYS.custom-keybinding:$shortcut"
	gsettings set "$binding" name "$2"
	gsettings set "$binding" command "$3"
	gsettings set "$binding" binding "$4"
}

# Super+Ctrl+W: random wallpaper and re-theme (same script as niri's Mod+Ctrl+W).
add_shortcut dotfiles-wallpaper-change "Random wallpaper" "$HOME/.local/bin/wallpaper-change.sh" "<Super><Control>w"

# Super+Return: open a terminal.
add_shortcut dotfiles-terminal "Terminal" ghostty "<Super>Return"
