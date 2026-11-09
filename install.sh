#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

stow -t ~ -d "$DOTFILES" \
	zsh \
	spaceship-prompt \
	albert \
	fastfetch \
	ghostty \
	wallpaper \
	matugen \
	bat \
	git \
	fzf \
	fd \
	claude \
	btop \
	micro \
	pay-respects \
	niri \
	dms \
	dfiles \
	npm

# DMS plugins (launcher web search, calculator, ...), pinned in the lockfile
dms plugins restore "$DOTFILES/dms/.config/dms/plugins.lock.json"

# Third-Party-Plugins
while read -r repo; do
	name=$(basename "$repo")
	target="$ZSH_CUSTOM/plugins/$name"
	[ -d "$target" ] || git clone --depth 1 "$repo" "$target"
done < "$DOTFILES/zsh/custom-plugins.txt"

# Third-Party-Themes
while read -r repo; do
	name=$(basename "$repo")
	target="$ZSH_CUSTOM/themes/$name"
	[ -d "$target" ] || git clone --depth 1 "$repo" "$target"
done < "$DOTFILES/zsh/custom-themes.txt"

ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Wallpaper colors
echo "Setting up wallpaper timer..."
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-change.timer

# dfiles Qt 6.8 workaround (see dfiles/.local/bin/dfiles-patch-ui.sh)
systemctl --user enable --now dfiles-patch-ui.service

echo "Setup complete"
