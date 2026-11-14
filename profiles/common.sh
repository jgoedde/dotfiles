#!/usr/bin/env bash
# Setup steps every machine gets. Run by install.sh after stowing.
set -e

DOTFILES="${DOTFILES:?DOTFILES must be set by install.sh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Third-party zsh plugins, cloned into the real $ZSH_CUSTOM (never into the repo)
mkdir -p "$ZSH_CUSTOM/plugins"
while read -r repo; do
	case "$repo" in "" | "#"*) continue ;; esac
	name=$(basename "$repo")
	target="$ZSH_CUSTOM/plugins/$name"
	[ -d "$target" ] || git clone --depth 1 "$repo" "$target"
done < "$DOTFILES/zsh/custom-plugins.txt"
