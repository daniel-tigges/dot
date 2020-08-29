#!/bin/sh

# These scripts installs all required packages and setup
# all dotfiles stored in my git repository.
# Start the script from your home directory
# Make sure to have arch properly installed and setup:
#	- user with sudo privileges
#	- package-groups base and base-devel has to be installed
#	- yay and git has to be installed

# Parameters
USER=$(whoami)
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
config submodule update --init --remote

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
sudo sed -i "/display-setup-script=/s/.*/display-setup-script=\/home\/daniel\/.local\/bin\/set-displays/" $LightDMConfig
sudo sed -i "/user-session=/s/.*/user-session=bspwm/" $LightDMConfig
sudo cp $HOME/.local/system/lightdm-mini-greeter.conf $LightDMGreeterConfig

# Change default shell
echo "Change default shell to zsh"
sudo chsh -s /usr/bin/zsh
sudo usermod --shell /usr/bin/zsh daniel

# Set locale
echo "Setting locale"
sudo sed -i "/de_DE.UTF-8 UTF-8/s/.*/de_DE.UTF-8 UTF-8/" /etc/locale.gen
sudo sed -i "/en_US.UTF-8 UTF-8/s/.*/en_US.UTF-8 UTF-8/" /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=de_DE.UTF-8
sudo localectl set-locale LC_MESSAGES=en_US.UTF-8

# Set keymap
echo "Setting keymap"
sudo localectl set-keymap de

# Auto enable bluetooth
sudo systemctl enable bluetooth && sudo systemctl start bluetooth
sudo sed -i "/AutoEnable=/s/.*/AutoEnable=true/" /etc/bluetooth/main.conf
sudo sed -i "/DiscoverableTimeout =/s/.*/DiscoverableTimeout = 0/" /etc/bluetooth/main.conf
sudo sed -i "/Discoverable =/s/.*/Discoverable = true/" /etc/bluetooth/main.conf
sudo btmgmt ssp off

# Enable multilib repository
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Link bspswallo script from git submodule
chmod +x $HOME/.local/share/bspswallow/alternative/bspswallow
ln -s /home/daniel/.local/share/bspswallow/bspswallow /home/daniel/.local/bin/bspswallow

# Add system services
sudo cp $HOME/.local/system/audio-update.service /etc/systemd/system/audio-update.service
systemctl enable audio-update.service

# Add udev rules
sudo cp $HOME/.local/system/80-headset-state-changed.rules /etc/udev/rules.d/80-headset-state-changed.rules
sudo cp $HOME/.local/system/81-monitor-hotplug.rules /etc/udev/rules.d/81-monitor-hotplug.rules

# Enable Virtualization
sudo systemctl enable libvirtd
sudo groupadd libvirtd
sudo usermod -G libvirtd -a $USER

# Enable ssh daemon
sudo systemctl enable sshd

# Remove old bash files
[ -f $HOME/.bash_history ] && rm $HOME/.bash_history
[ -f $HOME/.bash_logout ] && rm $HOME/.bash_logout
[ -f $HOME/.bash_profile ] && rm $HOME/.bash_profile
[ -f $HOME/.bashrc ] && rm $HOME/.bashrc

# Set inital pywal theme
wal --theme sexy-material

echo "Done. Restart system..."
