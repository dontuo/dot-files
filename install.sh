#!/bin/bash

# Install packages
sudo pacman -S --noconfirm --needed - <pacman.txt

# move dot-files to .config folder
cp .config/* ~/.config/
cp .bashrc ~
#installing yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si


