export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

plugins=(
    git
    sudo
    web-search
    zsh-fzf-history-search
    zsh-autosuggestions
    fast-syntax-highlighting
    dirhistory
)
source $ZSH/oh-my-zsh.sh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory