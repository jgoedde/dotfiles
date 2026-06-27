export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.local/bin/

ZSH_THEME="spaceship"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

eval "$(zoxide init zsh --cmd cd)"

if [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
    [[ -f ~/.inshellisense/init/zsh/init.zsh ]] && source ~/.inshellisense/init/zsh/init.zsh
fi

# -----------------------------------------------------
# Aliases
# -----------------------------------------------------
source $ZSH_CUSTOM/gnuke.zsh
source $ZSH_CUSTOM/gpatch.zsh
source $ZSH_CUSTOM/filemanager.zsh
source $ZSH_CUSTOM/files.zsh

# -----------------------------------------------------
# Fastfetch
# -----------------------------------------------------
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi
