#!/bin/bash

# Install packages
sudo pacman -S --noconfirm --needed - <pacman.txt

mkdir ~/Pictures
# move dot-files to .config folder
cp .config/* ~/.config/
cp .bashrc ~
cp -r wallpapers/ ~/Pictures/
#installing yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S --noconfirm --needed - <yay.txt 


