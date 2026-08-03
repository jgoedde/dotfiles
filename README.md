## My Dots ⚙️ for Productivity

my personal dotfiles, tested and used on Ubuntu 24 & 22 (Zorin OS)

<img width="500" alt="image" src="https://github.com/user-attachments/assets/71f499c6-70d4-4433-8568-c97c7b775940" />

## Table Of Contents

<!-- TOC -->

* [My Dots ⚙️ for Productivity](#my-dots--for-productivity)
* [Table Of Contents](#table-of-contents)
* [Components overview](#components-overview)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
    * [What install.sh installs](#what-installsh-installs)
    * [Desktop configuration](#desktop-configuration)
* [How Wallpapers work](#how-wallpapers-work)
* [Font used](#font-used)
* [Inspirations](#inspirations)

<!-- TOC -->

## Components overview

- GNU stow to create symlinks to actual user directories
- Terminal: [kitty](https://github.com/kovidgoyal/kitty)
- Shell: zsh
    - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) for theming and plugins
    - [`spaceship prompt`](https://github.com/spaceship-prompt/spaceship-prompt)
    - [`fzf`](https://github.com/junegunn/fzf) (fuzzy file utility)
    - [`bat`](https://github.com/sharkdp/bat) (better cat)
    - [`fastfetch`](https://github.com/fastfetch-cli/fastfetch) on launch
    - [`eza`](https://github.com/eza-community/eza) for a better `ls` with icons & colors
    - [`zoxide`](https://github.com/ajeetdsouza/zoxide) for smarter `cd`
- File manager: Thunar file manager with Kitty integration
- Launcher: [albert](https://github.com/albertlauncher/albert) launcher with search engines like Duden, YouTube, Google
  Maps etc.
    - themed with a matugen-generated Material You palette (see below [Wallpapers](#how-wallpapers-work) section)
- [matugen](https://github.com/InioX/matugen)
    - generates themes based on wallpaper (see below [Wallpapers](#how-wallpapers-work) section)
- git config for local ignores and aliases
- [pywalfox](https://github.com/frewacom/pywalfox) to use the material colors in Firefox
- [`fd`](https://github.com/sharkdp/fd) for better `find`
- `$EDITOR`/`$VISUAL` set to `jetedit` (`zsh/.local/bin/jetedit`), a wrapper that opens whatever JetBrains Toolbox IDE
  is installed in LightEdit mode

## Prerequisites

- git
- stow
- zsh
- kitty
- oh-my-zsh

## Installation

```shell
git clone https://github.com/jgoedde/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

### What install.sh installs

`install.sh` is doing three things:

1. stowing the config dirs
2. installing the zsh plugins and spaceship prompt
3. setting up the wallpaper change timer

It does not download any other dependencies that are listed in Components section. Install them yourself.

### Desktop configuration

After installing kitty, set it as default terminal.

```sh
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
```

After installing Thunar, set it as default application for files.

```shell
xdg-mime default thunar.desktop inode/directory
```

## How Wallpapers work

Walls are expected to live in `$HOME/Pictures/walls`
A systemd timer is set up every hour to change to a random wallpaper from the dir. Then, matugen is used to generate
themes for following apps:

- kitty colors
- bat
- gtk (v3 and v4)
- obsidian
- pywalfox
- fzf
- alberts `widgetsboxmodel` theme (restarts albert to apply, via
  `albert restart`)

The generated kitty/bat/fzf color configs are committed to the repo (and marked
`skip-worktree` locally) so a fresh clone has working colors before matugen ever runs.

## Font used

[_Hack Nerd Font_](https://www.nerdfonts.com/font-downloads), used in `kitty/.config/kitty/kitty.conf`

## Inspirations

- Stefan Raabe, https://github.com/mylinuxforwork/dotfiles
- rockyzhang24, https://github.com/rockyzhang24/dotfiles
