#!/bin/sh

# These scripts installs all required packages and setup
# all dotfiles stored in my git repository.
# Start the script from your home directory
# Make sure to have arch properly installed and setup:
#	- user with sudo privileges
#	- package-groups base and base-devel has to be installed
#	- yay and git has to be installed

# Parameters
DotDirectory="$HOME/.dotfiles/"
LightDMConfig="/etc/lightdm/lightdm.conf"
LightDMGreeterConfig="/etc/lightdm/lightdm-mini-greeter.conf"

# Get dependent packages
echo "Get package list"
mkdir -p $HOME/.local
curl -Lks https://raw.githubusercontent.com/daniel-tigges/dot/master/.local/packages > $HOME/.local/packages

# Install dependent packages
echo "Install packages"
yay -Sy --needed --noconfirm - < $HOME/.local/packages

echo "Check out dotfiles"
git clone --recurse-submodules --bare https://github.com/daniel-tigges/dot.git $DotDirectory
function config {
   /usr/bin/git --git-dir=$DotDirectory --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Check out succesfull";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p $HOME/.config-backup/{} && mv {} $HOME/.config-backup/{}'
fi;
config checkout
config config status.showUntrackedFiles no

# create directories and files
echo "Create default directories"
mkdir -p $HOME/.cache/zsh # to store history file
mkdir -p $HOME/.config/wget # for wget configuration
touch $HOME/.config/wget/wgetrc # for wget configuration

# Enable lightdm
echo "Enable lightdm"
sudo systemctl enable lightdm
# Configure lightdm and mini-greeter
echo "Configure lightdm and greeter"
sudo sed -i "/user-authority-in-system-dir=/s/.*/user-authority-in-system-dir=true/" $LightDMConfig
sudo sed -i "/greeter-session=/s/.*/greeter-session=lightdm-mini-greeter/" $LightDMConfig
sudo sed -i "/user-session=/s/.*/user-session=bspwm/" $LightDMConfig
sudo cp $HOME/.local/share/lightdm-mini-greeter.conf $LightDMGreeterConfig

echo "Done. Restart system..."
