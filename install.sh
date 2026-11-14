#!/usr/bin/env bash
# Install the dotfiles: stow Common plus one profile, then run their setup scripts.
#
#   ./install.sh <profile>   apply a profile and remember it
#   ./install.sh             re-apply the remembered profile
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES="$DOTFILES/profiles"
STATE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile"
export DOTFILES

available_profiles() {
	for f in "$PROFILES"/*.txt; do
		name=$(basename "$f" .txt)
		[ "$name" = common ] || echo "$name"
	done
}

usage() {
	echo "Usage: $0 <profile>" >&2
	echo "Profiles: $(available_profiles | tr '\n' ' ')" >&2
	echo "Without an argument, the profile saved in $STATE_FILE is reused." >&2
}

if [ $# -gt 1 ]; then
	usage
	exit 1
fi

profile="$1"
if [ -z "$profile" ]; then
	if [ -s "$STATE_FILE" ]; then
		profile=$(<"$STATE_FILE")
		echo "Reusing saved profile: $profile"
	else
		usage
		exit 1
	fi
fi

if [[ ! $profile =~ ^[A-Za-z0-9_-]+$ ]] || [ "$profile" = common ] || [ ! -f "$PROFILES/$profile.txt" ]; then
	echo "Unknown profile: '$profile'" >&2
	usage
	exit 1
fi

read_packages() {
	grep -v -e '^[[:space:]]*$' -e '^[[:space:]]*#' "$1"
}

mapfile -t packages < <(read_packages "$PROFILES/common.txt"; read_packages "$PROFILES/$profile.txt")

# --no-folding: link files, never whole directories, so nothing written into
# ~/.config/<app> (e.g. plugin clones) can end up inside the repo.
stow --no-folding -t "$HOME" -d "$DOTFILES" "${packages[@]}"

mkdir -p "$(dirname "$STATE_FILE")"
echo "$profile" >"$STATE_FILE"

for script in "$PROFILES/common.sh" "$PROFILES/$profile.sh"; do
	if [ -f "$script" ]; then
		echo "Running $(basename "$script")..."
		bash "$script"
	fi
done

echo "Setup complete ($profile)"
