#!/bin/bash


# Install packages
sudo pacman -S --noconfirm --needed - <pacman.txt

mkdir .config/
mkdir ~/Pictures
# move dot-files to .config folder
cp -r .config/* ~/.config/
cp .bashrc ~
cp -r wallpapers/ ~/Pictures/



#installing yay

pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort pacman.txt))
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S --noconfirm --needed wlogout swww waypaper
 


