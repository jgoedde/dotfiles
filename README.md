# dotfiles

Personal dotfiles for **Zorin OS 17** (Ubuntu 22.04 base) managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **Shell:** zsh + [oh-my-zsh](https://ohmyz.sh/) + [spaceship-prompt](https://spaceship-prompt.sh/)
- **Terminal:** [kitty](https://sw.kovidgoyal.net/kitty/)
- **File Manager:** Thunar
- **Launcher:** [albert](https://albertlauncher.github.io/)
- **Shell tools:**
    - [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
    - [fzf](https://github.com/junegunn/fzf) — fuzzy finder
    - [eza](https://github.com/eza-community/eza) — modern `ls`
    - [fastfetch](https://github.com/fastfetch-cli/fastfetch) — system info on shell start
    - [inshellisense](https://github.com/microsoft/inshellisense) — IDE-style shell completions
- zsh
  plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search), [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) —
  cloned by `install.sh`
- **Wallpaper:** systemd timer (`wallpaper-change.timer`) cycles wallpapers automatically
- **Font:** [Hack Nerd Font Mono](https://www.nerdfonts.com/) — required for icons in kitty, eza, fastfetch

## Install

```sh
git clone https://github.com/jgoedde/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` stows configs, clones zsh plugins/themes, installs inshellisense via npm, enables the wallpaper-change
systemd timer, and warns about missing system packages.

After installing kitty, set it as default terminal.

```sh
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
```

After installing Thunar, set it as default application for files.

```shell
xdg-mime default thunar.desktop inode/directory
```

In order to register albert trigger on super key, clear it's value first.
```sh
gsettings set org.gnome.mutter overlay-key ''
```

## Prerequisites (not auto-installed)

Install these **before** running `install.sh`. Marked with ⚠️ where `apt install` is not enough.

| Tool                   | Install                                                                                                               |
|------------------------|-----------------------------------------------------------------------------------------------------------------------|
| oh-my-zsh ⚠️           | [ohmyz.sh](https://ohmyz.sh/) — curl installer                                                                        |
| kitty ⚠️               | [docs](https://sw.kovidgoyal.net/kitty/binary/) — official installer script, apt package is outdated                  |
| Hack Nerd Font Mono ⚠️ | [nerdfonts.com](https://www.nerdfonts.com/font-downloads) — download, unzip to `~/.local/share/fonts`, `fc-cache -fv` |
| eza ⚠️                 | [install guide](https://github.com/eza-community/eza/blob/main/INSTALL.md) — needs PPA or cargo                       |
| albert ⚠️              | [albertlauncher.github.io](https://albertlauncher.github.io/installing/) — needs PPA                                  |
| stow                   | `sudo apt install stow`                                                                                               |
| zoxide                 | `sudo apt install zoxide`                                                                                             |
| fzf                    | `sudo apt install fzf`                                                                                                |
| fastfetch              | `sudo apt install fastfetch`                                                                                          |
| npm                    | `sudo apt install nodejs npm`                                                                                         |
| pyenv ⚠️               | [github.com/pyenv/pyenv](https://github.com/pyenv/pyenv#installation) — curl installer                                |
