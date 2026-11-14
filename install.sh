#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

stow -t ~ -d "$DOTFILES" \
	zsh \
	albert \
	fastfetch \
	kitty \
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
	npm

# Third-Party-Plugins
while read -r repo; do
	name=$(basename "$repo")
	target="$ZSH_CUSTOM/plugins/$name"
	[ -d "$target" ] || git clone --depth 1 "$repo" "$target"
done < "$DOTFILES/zsh/custom-plugins.txt"

# Wallpaper colors
echo "Setting up wallpaper timer..."
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-change.timer

echo "Setup complete"
