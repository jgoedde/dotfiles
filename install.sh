#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

stow -t ~ -d "$DOTFILES" zsh albert inshellisense

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

# System-Pakete prüfen (nicht automatisch installieren, nur warnen)
echo "Prüfe System-Abhängigkeiten..."

if command -v pacman &>/dev/null; then
  PKG_HINT="sudo pacman -S"
elif command -v apt &>/dev/null; then
  PKG_HINT="sudo apt install"
elif command -v dnf &>/dev/null; then
  PKG_HINT="sudo dnf install"
else
  PKG_HINT="<dein Paketmanager>"
fi

while read -r pkg; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
  if ! command -v "$pkg" &>/dev/null; then
    echo "  fehlt: $pkg (z.B. mit '$PKG_HINT $pkg' installieren)"
  fi
done < "$DOTFILES/system-packages.txt"

echo "Installing inshellisense"

npm install -g @microsoft/inshellisense

echo "Setup complete"
