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
sudo pacman -S --needed htop btop blueman bluez-utils thunar kitty lazygit neofetch neovim qbittorrent ttf-font-awesome ttf-terminus-nerd vlc pulseaudio pipewire git xdg-desktop-portal-hyprland-git wofi pipewire  grim slurp pipewire-audio pipewire-pulse wireplumber wl-clipboard hyprland waybar zerotier-one wayvnc neovide pavucontrol firefox
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S --noconfirm --needed wlogout swww waypaper
 


