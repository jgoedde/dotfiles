#-----------------------------------
# fzf
#-----------------------------------
source "$HOME/.config/fzf/fzf-config"

#-----------------------------------
# zoxide
#-----------------------------------
export _ZO_DOCTOR=0

# Get pager only when useful
# -F quits immediately if the output fits on one screen.
# -R keeps colors.
# -X leaves the output visible after quitting.
export LESS=-FRX

#-----------------------------------
# pay-respects (https://github.com/iffse/pay-respects)
#-----------------------------------
if (( $+commands[pay-respects] )); then
  # Matugen writes only the [colors] layer here; pay-respects merges it below ~/.config/pay-respects/config.toml.
  # Appended, so other apps give it the lowest precedence.
  export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}:$HOME/.cache/matugen/xdg"
  eval "$(pay-respects zsh --alias fuck)"
fi
