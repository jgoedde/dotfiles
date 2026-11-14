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

# btop rewrites btop.conf on every exit in its own version's format, so the file is
# per machine and not tracked. Only the matugen theme is enforced.
BTOP_CONF="$HOME/.config/btop/btop.conf"
mkdir -p "$(dirname "$BTOP_CONF")"
# Machines stowed before btop.conf left the repo still have a symlink (maybe dangling).
# Swap it for a real copy so btop stops writing into the repo.
if [ -L "$BTOP_CONF" ]; then
	tmp=$(mktemp)
	cp "$BTOP_CONF" "$tmp" 2>/dev/null || true
	rm "$BTOP_CONF"
	mv "$tmp" "$BTOP_CONF"
fi
if grep -q '^color_theme' "$BTOP_CONF" 2>/dev/null; then
	sed -i 's/^color_theme.*/color_theme = "matugen"/' "$BTOP_CONF"
else
	printf 'color_theme = "matugen"\n' >> "$BTOP_CONF"
fi
