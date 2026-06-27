alias ..='cd ..'
alias ls="eza -a --icons=always"
alias ll="eza -al --icons=always"
alias lt="eza -a --tree --level=1 --icons=always"
alias shutdown="systemctl poweroff"
alias gmain="gnuke && git switch main && git pull"
alias gmaster="gnuke && git switch master && git pull"
alias ff="fastfetch"
alias bat="batcat"

# bat for --help and -h
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
