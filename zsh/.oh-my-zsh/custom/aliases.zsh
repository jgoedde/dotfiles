alias ..='cd ..'
alias ls="eza -a --icons=always"
alias ll="eza -al --icons=always"
alias lt="eza -a --tree --level=1 --icons=always"
alias shutdown="systemctl poweroff"
alias ff="fastfetch"
alias cat="bat"
alias knew='(setsid kitty --directory="$PWD" >/dev/null 2>&1 &); exit'

# bat for --help and -h
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
