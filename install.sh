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
cd ..
#installing packages
sudo pacman -Syu --noconfirm

#sudo pacman -S --noconfirm --needed - <pacman.txt
#yay -S --noconfirm - <yay.txt

# Install packages from the list
sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
sudo yay -S --needed $(comm -12 <(yay -Slq | sort) <(sort pkglist.txt))

#yay -Rsu $(comm -23 <(yay -Qq | sort) <(sort pacman.txt))
#pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort pacman.txt))
 


