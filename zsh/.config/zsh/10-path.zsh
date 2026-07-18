export PATH=$PATH:~/.local/bin/

#-----------------------------------
# NVM
#-----------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#-----------------------------------
# pnpm
#-----------------------------------
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

#-----------------------------------
# pyenv
#-----------------------------------
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

#-----------------------------------
# zoxide
#-----------------------------------
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

#-----------------------------------
# brew
#-----------------------------------
if [[ -d /home/linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

#-----------------------------------
# deno
#-----------------------------------
[ -d $HOME/.deno ] && source "$HOME/.deno/env"
