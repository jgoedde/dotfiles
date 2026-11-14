<h1>My Dots ⚙️ for Productivity</h1>

my personal dotfiles for several Linux machines: GNOME on Ubuntu / Zorin OS, niri with DankMaterialShell on
Debian 13

<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/13a8f46f-9c18-442b-956c-bfe06611d3da" />

<h2>Table Of Contents</h2>

<!-- TOC -->

* [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [What install.sh does](#what-installsh-does)
    * [Switching from the wallpaper timer](#switching-from-the-wallpaper-timer)
* [Common](#common)
    * [Shell](#shell)
    * [Tools](#tools)
    * [Theming with matugen](#theming-with-matugen)
    * [Machine-local overrides](#machine-local-overrides)
* [GNOME](#gnome)
* [niri](#niri)
* [Font and cursor](#font-and-cursor)
* [Inspirations](#inspirations)

<!-- TOC -->

## Installation

Packages are the top-level folders; each mirrors `$HOME` and is linked into place by GNU stow as one unit. A profile is
a list of packages in `profiles/<name>.txt`, with an optional setup script `profiles/<name>.sh` beside it. Every machine
gets the `common` profile plus exactly one of `gnome` or `niri`.

```shell
git clone https://github.com/jgoedde/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh <profile>   # gnome or niri
```

The chosen profile is saved in `~/.config/dotfiles/profile`. Later runs of `./install.sh` without an argument reuse it,
so after a `git pull` a plain `./install.sh` re-applies everything.

The repo is expected at `~/dotfiles`.

### Prerequisites

- git, stow, zsh, oh-my-zsh, ghostty
- systemd user session, jq, `xdg-user-dir` (xdg-user-dirs)
- the tools named below for your profile; `install.sh` installs none of them

### What install.sh does

1. stows `common` plus the chosen profile with `--no-folding`
2. runs `profiles/common.sh`: zsh plugin clones into `$ZSH_CUSTOM`
3. runs the profile's setup script:
    - `profiles/gnome.sh`: ghostty as default terminal, `Super+Ctrl+W` random-wallpaper shortcut
    - `profiles/niri.sh`: DMS plugin restore, dfiles service, `matugen-sync`

Why `--no-folding`: by default stow links a whole directory (e.g. `~/.config/btop -> ~/dotfiles/btop/.config/btop`)
when only one package owns it. Then everything an app writes there (themes, caches, plugin clones, `systemctl enable`
links) lands inside the repo. With `--no-folding` stow creates real directories and links files one by one.

Machines stowed before `--no-folding` still have whole directories linked into the repo (e.g. `~/.config/systemd`).
stow keeps those as they are. Unfold them once by unstowing everything and installing again:

```shell
cd ~/dotfiles
stow -D -t ~ $(cat profiles/*.txt)
./install.sh <profile>
```

### Switching from the wallpaper timer

> Temporary: remove this section once every machine has switched.

Machines set up before `matugen-sync` still run the hourly `wallpaper-change.timer` (and the old `matugen-mode-sync`
watcher). Disable them once, drop the dangling unit links, then reinstall:

```shell
systemctl --user disable --now wallpaper-change.timer matugen-mode-sync.path
rm -f ~/.config/systemd/user/{wallpaper-change.timer,wallpaper-change.service,matugen-mode-sync.path,matugen-mode-sync.service}
cd ~/dotfiles && ./install.sh <profile>
```

## Common

Packages in `profiles/common.txt`, identical on every machine.

### Shell

- `zsh`: zsh with [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and its built-in `robbyrussell` theme
    - modular config: `~/.zshrc` only sources `~/.config/zsh/*` in order
    - third-party plugins listed in `zsh/custom-plugins.txt` (autosuggestions, fzf history search, fast syntax
      highlighting), cloned by `common.sh`
    - [`eza`](https://github.com/eza-community/eza) for a better `ls`, [`zoxide`](https://github.com/ajeetdsouza/zoxide)
      for smarter `cd`
- `fastfetch`: [fastfetch](https://github.com/fastfetch-cli/fastfetch) on launch
- `ghostty`: [ghostty](https://github.com/ghostty-org/ghostty) terminal, matugen themed

### Tools

- `git`: config for local ignores and aliases (`pull.rebase`, `push.autoSetupRemote`, `rerere`)
- `fzf`: [fzf](https://github.com/junegunn/fzf) fuzzy finder with previewer and `fzf-git`, matugen themed
- `fd`: [fd](https://github.com/sharkdp/fd) for better `find`, also used as fzf source
- `bat`: [bat](https://github.com/sharkdp/bat) (better cat), matugen themed
- `btop`: [btop](https://github.com/aristocratos/btop), matugen themed
- `micro`: [micro](https://github.com/zyedidia/micro) text editor, matugen themed
- `pay-respects`: [pay-respects](https://github.com/iffse/pay-respects) corrects the last command. matugen only writes
  the `[colors]` layer to `~/.cache/matugen/xdg/`, added to `XDG_CONFIG_DIRS`; settings stay in the package
- `claude`: Claude Code settings + status line (via [`ccstatusline`](https://github.com/sirmalloc/ccstatusline))
- `npm`: `.npmrc` with funding messages disabled

### Theming with matugen

Two packages carry the pipeline:

- `matugen`: [matugen](https://github.com/InioX/matugen) templates and `config.toml`, which DMS also reads
- `wallpaper`: `wallpaper-change.sh` (random wallpaper), `matugen-apply.sh` (render the templates) and the
  `matugen-sync` units (enabled only on niri)

Walls are expected to live in `<XDG pictures dir>/Walls` (e.g. `~/Pictures/Walls` or `~/Bilder/Walls`; override with
`WALLS_DIR`). `wallpaper-change.sh` picks a random one (never the current one) and sets it via DMS when it is running,
otherwise via GNOME `gsettings`. Then `matugen-apply.sh` runs matugen, with its post hooks, using the light/dark mode,
scheme and contrast set in DMS. Without DMS, it uses dark mode and `scheme-content`. It themes:

- bat, fzf, btop, micro, pay-respects
- ghostty (dark palette even in light mode; open windows reload via `USR2`)
- pywalfox: [pywalfox](https://github.com/frewacom/pywalfox) uses the colors in Firefox
- obsidian: the snippet holds both palettes (`.theme-dark` / `.theme-light`), so with Obsidian's base color scheme set
  to "Adapt to system" it switches instantly
- GNOME only: gtk3/gtk4, albert (see [GNOME](#gnome))

The run config is `config.toml` (the templates for every machine, also read by DMS) plus every
`~/.config/matugen/config.d/*.toml` fragment that a profile's packages add. Only `matugen-gnome` adds one,
so niri never renders the GNOME templates.

The generated color configs (bat, fzf, btop, micro, ghostty) are not tracked and are listed in `.gitignore`. Run
`matugen-apply.sh` once on a fresh clone to create them (without DMS, pass the wallpaper path:
`matugen-apply.sh <wallpaper>`).

### Machine-local overrides

Untracked files that adjust one machine without touching the repo:

- `~/.config/zsh/custom/<same-filename>`: replaces the matching file from `~/.config/zsh/`
- `~/.zshrc_custom`: sourced last by `~/.zshrc`
- `~/.local/bin/wallpaper-post.sh`: runs after every `matugen-apply.sh`, e.g. to copy the Obsidian snippet into a vault
  (see `wallpaper-post.example.sh`)

## GNOME

Packages in `profiles/gnome.txt`:

- `albert`: [Albert](https://albertlauncher.github.io) launcher on `Ctrl+O` with web search fallbacks and plugins
  (apps, calculator, Firefox history, JetBrains projects, Obsidian, emoji, …), matugen themed
- `matugen-gnome`: GNOME-only matugen templates and post hooks (gtk3/gtk4, albert) and their
  `config.d/gnome.toml` fragment

`profiles/gnome.sh` sets, via `gsettings`:

- ghostty as default terminal
- a `Super+Ctrl+W` custom shortcut running `wallpaper-change.sh`; re-running it does not add a second one

The wallpaper changes on demand only: press `Super+Ctrl+W` for a new random wallpaper and a fresh theme.

## niri

Packages in `profiles/niri.txt`:

- `niri`: [niri](https://github.com/YaLTeR/niri) compositor config
    - only hand-maintained files are tracked (`config.kdl`, `dms/binds.kdl`, `dms/windowrules.kdl`); the other
      `niri/dms/*.kdl` includes (colors, layout, input, …) are regenerated by DMS
    - `xdg-desktop-portal/niri-portals.conf` routes file pickers to DMS Files (`dfiles`), gtk as fallback. Firefox only
      uses the portal picker with `widget.use-xdg-desktop-portal.file-picker = 1` (set in the profile's `user.js`)
- `dms`: [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) settings and launcher plugins
    - launcher: DMS spotlight bar (`Ctrl+O`) with the [`webSearch`](https://github.com/devnullvoid/dms-web-search) and
      [`calculator`](https://github.com/rochacbruno/DankCalculator) plugins, both without trigger prefix
    - search engines by keyword, e.g. `d <word>` (DWDS), `gh`, `y` (YouTube), `gm` (Google Maps),
      `deen`/`ende`/`dwrite` (DeepL); any other query offers Google and the other engines
    - typed URLs/domains (`fast.com`, `localhost:3000`) open directly in the default browser via the local `urlOpener`
      plugin, ranked above the other plugins (`launcherPluginOrder` in `settings.json`)
    - Firefox history via the local `firefoxHistory` plugin (no trigger, refreshes every 2 min from a copy of
      `places.sqlite`; favicons cached in `~/.cache/dms-firefox-history`)
    - configured in `dms/.config/dms/plugin_settings.json`; plugins pinned in `plugins.lock.json` and restored by
      `niri.sh` (`dms plugins restore`)
- `dfiles`: workaround for DMS Files on Debian 13 (Qt 6.8), whose UI never loads. `dfiles-patch-ui.service` extracts
  and patches the UI at login; remove the package once upstream is fixed (see `dfiles-patch-ui.sh`)

Wallpapers: pick one in the DMS wallpaper browser (`Mod+Y`), or press `Mod+Ctrl+W` for a random one. DMS renders the
`config.toml` templates itself but skips their post hooks, so the `matugen-sync.path` unit watches DMS's
`session.json` and re-runs `matugen-apply.sh` when the wallpaper or the light/dark mode changed since the last run
(both are recorded in `~/.cache/matugen/last-apply`). Other session changes are ignored.

GTK 3/4 colors come from DMS itself (`dank-colors.css`, enabled once via DMS settings → "Apply GTK colors").

## Font and cursor

- Font: ~~[_Hack Nerd Font_](https://www.nerdfonts.com/font-downloads)~~ _JetBrains Mono_, ghostty's built-in default
- Cursor: a macOS cursor theme on both profiles, installed and selected by hand (not themed by matugen)

## Inspirations

- Stefan Raabe, https://github.com/mylinuxforwork/dotfiles
- rockyzhang24, https://github.com/rockyzhang24/dotfiles
