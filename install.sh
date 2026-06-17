#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME}/.oh-my-zsh/custom"

stow -t ~ -d "$DOTFILES" zsh albert

while read -r repo; do
	name=$(basename "$repo")
	target="$ZSH_CUSTOM/plugins/$name"
	[ -d "$target" ] || git clone --depth 1 "$repo" "$target"
done < "$DOTFILES/zsh/custom-plugins.txt"

echo "Setup complete"

