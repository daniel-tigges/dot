#!/bin/sh

dot-directory="$HOME/.dotfiles/"

git clone --bare https://github.org/daniel-tigges/dot.git $dot-directory
function config {
   /usr/bin/git --git-dir=dot-directory --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

# create directories
mkdir -p $HOME/.cache/zsh # to store history file
