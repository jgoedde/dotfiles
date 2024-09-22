#!/usr/bin/env bashgit clone --bare git@github.com:jgoedde/dotfiles.git $HOME/.dotfiles
function config {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles from git@github.com:jgoedde/dotfiles.git";
  else
    echo "Moving existing dotfiles to ~/.dotfiles-backup";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi
config checkout
config config status.showUntrackedFiles no
