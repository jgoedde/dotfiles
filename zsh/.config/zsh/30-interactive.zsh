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

# Greeting
if [[ $(tty) == *"pts"* && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
    fastfetch
fi

# zoxide: keep last, it must hook in after everything else.
export _ZO_DOCTOR=0
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
