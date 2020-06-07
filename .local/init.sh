#!/bin/sh

# These scripts installs all required packages and setup
# all dotfiles stored in my git repository.
# Make sure to have arch properly installed and setup:
#	- user with sudo privileges
#	- package-groups base and base-devel has to be installed
#	- yay and git has to be installed

# Parameters
DotDirectory="$HOME/.dotfiles/"

# Install dependent packages
yay -Sy --needed --noconfirm - < $HOME/.local/packages

git clone --bare https://github.org/daniel-tigges/dot.git $DotDirectory
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

# create directories and files
mkdir -p $HOME/.cache/zsh # to store history file
mkdir -o $HOME/.config/wget # for wget configuration
touch $HOME/.config/wget/wgetrc # for wget configuration
