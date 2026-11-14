# Environment: exported variables and PATH. Nothing interactive belongs here.

# Opt out to tracking. Some applications support this. (`gh` CLI for example).
# https://donottrack.sh
export DO_NOT_TRACK=1

# Get pager only when useful
# -F quits immediately if the output fits on one screen.
# -R keeps colors.
# -X leaves the output visible after quitting.
export LESS=-FRX

export PATH=$PATH:$HOME/.local/bin/
export PATH=$PATH:/usr/local/go/bin

# brew
[[ -d /home/linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

# deno
[ -d $HOME/.deno ] && source "$HOME/.deno/env"

# go
command -v go >/dev/null && export PATH="$PATH:$(go env GOPATH)/bin"
