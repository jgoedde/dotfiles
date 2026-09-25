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
