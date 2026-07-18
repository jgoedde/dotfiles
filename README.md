# My Dots ⚙️ for Productivity

my personal dotfiles, tested and used on Ubuntu 24 & 22 (Zorin OS)

{insert sc here}

<!-- TOC -->
* [My Dots ⚙️ for Productivity](#my-dots--for-productivity)
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
- Terminal: kitty
- Shell: zsh
    - oh-my-zsh for theming and plugins
        - spaceship prompt
    - fzf (fuzzy file utility)
    - bat (better cat)
    - fastfetch on launch
    - eza for a better `ls` with icons & colors
    - zoxide for smarter `cd`
- File manager: Thunuar file manager with Kitty integration
- Launcher: albert launcher with [custom firefox plugin](https://github.com/jgoedde/albert-plugin-firefox) and search engines like
  Duden, YouTube, Google Maps etc.
- Matugen
    - generates themes based on wallpaper (see below _Wallpapers_ section)
- git config for local ignores and aliases
- pywalfox to use the material colors in Firefox

## Prerequisites

- git
- stow
- zsh
- kitty
- oh-my-zsh

## Installation

```shell
git clone --recurse-submodules https://github.com/jgoedde/dotfiles ~/dotfiles
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
A systemd timer is set up every hour to change to a random wallpaper from the dir.
Then, matugen is used to generate themes for following apps:

- kitty colors
- bat
- gtk (v3 and v4)
- obsidian
- pywalfox

## Font used

[_Hack Nerd Font_](https://www.nerdfonts.com/font-downloads), used in `kitty/.config/kitty/kitty.conf`

## Inspirations

- Stefan Raabe, https://github.com/mylinuxforwork/dotfiles
