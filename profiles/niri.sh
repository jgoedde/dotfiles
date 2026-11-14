#!/usr/bin/env bash
# Setup steps for the niri profile. Run by install.sh after common.sh.
set -e

DOTFILES="${DOTFILES:?DOTFILES must be set by install.sh}"

# DMS plugins (launcher web search, calculator, ...), pinned in the lockfile
dms plugins restore "$DOTFILES/dms/.config/dms/plugins.lock.json"

# dfiles Qt 6.8 workaround (see dfiles/.local/bin/dfiles-patch-ui.sh)
systemctl --user daemon-reload
systemctl --user enable --now dfiles-patch-ui.service

# Re-theme the own matugen templates when the wallpaper or light/dark mode changes in DMS
systemctl --user enable --now matugen-sync.path
