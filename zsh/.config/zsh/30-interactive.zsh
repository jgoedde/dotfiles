# Interactive shell: tool hooks and startup output.

# fzf
source "$HOME/.config/fzf/fzf-config"

# pay-respects (https://github.com/iffse/pay-respects)
if (( $+commands[pay-respects] )); then
  # Matugen writes only the [colors] layer here; pay-respects merges it below ~/.config/pay-respects/config.toml.
  # Appended, so other apps give it the lowest precedence.
  export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}:$HOME/.cache/matugen/xdg"
  eval "$(pay-respects zsh --alias fuck)"
fi

# Completion menu. Palette indices only, so colours follow matugen via the ghostty theme.
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%K{0}%F{4}%B %d %b%f%k'
zstyle ':completion:*' list-rows-first true
zstyle ':completion:*' list-packed true
zstyle ':completion:*' select-prompt '%F{8}─ %l · %p ─%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'ma=1;30;44'

# Greeting
if [[ $(tty) == *"pts"* && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
    fastfetch
fi

# zoxide: keep last, it must hook in after everything else.
export _ZO_DOCTOR=0
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
