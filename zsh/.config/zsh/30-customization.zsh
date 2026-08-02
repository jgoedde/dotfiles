#-----------------------------------
# fzf
#-----------------------------------
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzf-colors.conf"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#-----------------------------------
# zoxide
#-----------------------------------
export _ZO_DOCTOR=0
