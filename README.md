# Dotfiles

My Linux setup: one shared shell and toolset, plus a desktop profile, either `gnome` or `niri` (with
DankMaterialShell). Colors come from the wallpaper via [matugen](https://github.com/InioX/matugen).

<img width="1918" height="1080" alt="screenshot" src="https://github.com/user-attachments/assets/13a8f46f-9c18-442b-956c-bfe06611d3da" />

## 1. Before you install

`install.sh` installs no software. Install these first, or it fails partway through.

**Every machine**

- `git`, `stow`, `zsh`
- [Oh My Zsh](https://ohmyz.sh). Install it **before** `install.sh` (its installer refuses to run once
  `~/.oh-my-zsh` exists) and delete the `~/.zshrc` it writes:

  ```shell
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  rm ~/.zshrc
  chsh -s "$(command -v zsh)"
  ```

- `eza`, `bat`, `fastfetch`. The shell calls these on every start (`ls`, `cat`, `--help`). Without them, every new
  terminal shows errors. On Debian/Ubuntu the binary is `batcat`, so add `mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat`.

**`gnome` profile**

- GNOME itself (`gsettings`)

**`niri` profile**

- niri, [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (`dms`), DMS Files (`dfiles`)

## 2. Install

```shell
git clone https://github.com/jgoedde/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh gnome   # or: ./install.sh niri
```

The profile is remembered. After a `git pull`, run plain `./install.sh`.

**If stow reports conflicts**, nothing has been changed yet. An app already wrote its own config where this repo
puts one. Move the listed files away and run `install.sh` again. On `niri` this is expected for
`~/.config/niri/config.kdl` and `~/.config/dms/*.json`.

Then create the first theme: put images in `~/Pictures/Walls` and press `Super+Ctrl+W` (GNOME) or `Mod+Ctrl+W`
(niri). Until then, bat, fzf, micro and ghostty run without their matugen colors.

## 3. Safe to install afterwards

None of these write over the linked config files, so install them in any order, whenever you like:

- matugen (needed for theming)
- ghostty, micro, btop, fzf + fd (on Debian/Ubuntu fd is `fdfind`, link it to `~/.local/bin/fd`), zoxide,
  pay-respects
- jq and xdg-user-dirs (used by the wallpaper scripts)
- wl-clipboard (fzf `Ctrl+Y` copy)
- Claude Code, plus Node.js for its status line (`npx ccstatusline`)
- pywalfox (Firefox colors), Obsidian
- `gnome` only: [Albert](https://albertlauncher.github.io) launcher (`Ctrl+O`)

**One rule:** `~/.zshrc` is a link into this repo. Don't let installers edit it. The shell already sets up nvm,
pnpm, pyenv, Homebrew, deno, go and zoxide if they are present.

- nvm: `PROFILE=/dev/null` before its install command
- fzf from git: `./install --no-update-rc` (or just use your package manager)
- deno, pnpm and others: decline any "add to your shell profile" step

If one slipped through: `git -C ~/dotfiles checkout zsh/.zshrc`.

## How it's organised

- **Package**: a top-level folder that mirrors `$HOME` (e.g. `zsh/`, `ghostty/`), linked by stow.
- **Profile**: a list of packages, `profiles/<name>.txt`, plus an optional setup script `profiles/<name>.sh`.
  Every machine gets `common` plus one desktop profile.

Machine-local changes, without touching the repo:

- `~/.config/zsh/custom/<file>` replaces the same file from `~/.config/zsh/`
- `~/.zshrc_custom` is sourced last
- `~/.local/bin/wallpaper-post.sh` runs after every re-theme (see `wallpaper-post.example.sh`)

## Inspirations

- Stefan Raabe, https://github.com/mylinuxforwork/dotfiles
- rockyzhang24, https://github.com/rockyzhang24/dotfiles
