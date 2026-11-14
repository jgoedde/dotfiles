alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls="eza -a --icons=always"
alias ll="eza -al --icons=always"
alias lt="eza -a --tree --level=1 --icons=always"
alias shutdown="systemctl poweroff"
alias ff="fastfetch"
alias cat="bat"

# Common aliases: Hand-picked from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/common-aliases/README.md
alias zshrc="${=EDITOR} ~/.zshrc"

# bat for --help and -h
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias dots="cd ~/dotfiles"

alias filemanager='fm'
alias files='fm'

# Open files or the current directory in the default app, detached from the shell.
function fm() {
  xdg-open "${@:-.}" >/dev/null 2>&1 &!
}
