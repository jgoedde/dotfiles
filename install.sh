#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

stow -t ~ -d "$DOTFILES" zsh albert inshellisense fastfetch kitty Thunar wallpaper matugen material-gnome bat git

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

while read -r pkg; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
  if ! command -v "$pkg" &>/dev/null; then
    echo "  fehlt: $pkg"
  fi
done < "$DOTFILES/system-packages.txt"

echo "Installing inshellisense"

npm install -g @microsoft/inshellisense

# Wallpaper colors
echo "Setting up wallpaper timer..."
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-change.timer

echo "Setup complete"
