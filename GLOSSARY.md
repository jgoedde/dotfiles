# Dotfiles

Personal configuration for several Linux machines, installed into `$HOME` with GNU stow.

## Language

**Package**:
A top-level directory of the repo that mirrors `$HOME`, linked into place by stow as one unit.
_Avoid_: module, component, config dir

**Profile**:
A named list of packages that together set up one kind of machine (e.g. `gnome`, `niri`). The installer applies exactly one profile on top of `common`.
_Avoid_: branch, flavour, environment, machine config

**Common**:
The profile every machine gets. It holds the packages that must be identical everywhere, such as the shell.
_Avoid_: base, shared, core

**Desktop adapter**:
The one executable at `~/.local/bin/desktop-adapter`, shipped by a Package in each desktop Profile (niri: `dms`, gnome: `matugen-gnome`). It answers the wallpaper, light/dark mode, matugen scheme and contrast, and sets the wallpaper and reloads the desktop theme, so the Common theming scripts never check which desktop they run on.
_Avoid_: backend, driver, desktop module

**Machine-local override**:
An untracked file on one machine (`~/.zshrc_custom`, `~/.config/zsh/custom/*`, `~/.local/bin/wallpaper-post.sh`) that adjusts behaviour without touching the repo.
_Avoid_: host config, local profile
