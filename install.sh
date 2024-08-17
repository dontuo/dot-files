#!/bin/bash


# Install packages
sudo pacman -S --noconfirm --needed - <pacman.txt

mkdir ~/.config/
mkdir ~/Pictures
# move dot-files to .config folder
cp -r .config/* ~/.config/
cp .bashrc ~
cp -r wallpapers/ ~/Pictures/



#installing yay

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

#installing packages
yay -Rsu $(comm -23 <(yay -Qq | sort) <(sort pacman.txt))
pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort pacman.txt))
 


