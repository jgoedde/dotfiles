# dotfiles

Personal dotfiles for **Zorin OS 17** (Ubuntu 22.04 base) managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **Shell:** zsh + [oh-my-zsh](https://ohmyz.sh/) + [spaceship-prompt](https://spaceship-prompt.sh/)
- **Terminal:** [kitty](https://sw.kovidgoyal.net/kitty/)
- **Launcher:** [albert](https://albertlauncher.github.io/)
- **Shell tools:**
    - [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
    - [fzf](https://github.com/junegunn/fzf) — fuzzy finder
    - [eza](https://github.com/eza-community/eza) — modern `ls`
    - [fastfetch](https://github.com/fastfetch-cli/fastfetch) — system info on shell start
    - [inshellisense](https://github.com/microsoft/inshellisense) — IDE-style shell completions (requires `npm`)
- **Font:** [Hack Nerd Font Mono](https://www.nerdfonts.com/) — required for icons in kitty, eza, fastfetch

## Install

```sh
git clone https://github.com/jg/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` stows configs, clones zsh plugins/themes, and warns about missing system packages.

After installing kitty, set it as default terminal.

```sh
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
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
