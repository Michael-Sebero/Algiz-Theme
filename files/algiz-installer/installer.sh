#!/bin/bash

su -c '
### ALGIZ THEME CHOICE SELECTION ###

echo -e "\e[1mSelect a Algiz Theme Variant\e[0m"
echo "1. DESKTOP"
echo "2. LAPTOP"

read -p "Enter your choice (1-2): " choice

### INSTALL NEEDED XFCE PACKAGES ###

if pacman -Qq | grep -q "^thunar$"; then
    pacman -Sy --noconfirm mugshot xfce4-panel-profiles lightdm-gtk-greeter-settings artix-dark-theme

    ### CLONE ALGIZ THEME FILES ###

    echo -e "\e[1mCloning Algiz Theme files...\e[0m"
    mkdir -p /home/algiz-files/
    git clone https://github.com/Michael-Sebero/Algiz-Theme /home/algiz-files/
    cd /home/algiz-files/files/algiz-packages/

    ### REMOVE OLD XFCE DIRECTORIES ###

    echo -e "\e[1mRemoving old xfce directories from /home/$USER...\e[0m"
    find /home/$USER -maxdepth 1 -type d -iname "*xfce*" -exec rm -rf {} +

    # DESKTOP SELECTION
    if [ "$choice" = "1" ]; then
      unzip -o algiz-dotfiles-desktop.zip -d /home/$USER/
      unzip -o algiz-root-main.zip -d /
    fi

    # LAPTOP SELECTION
    if [ "$choice" = "2" ]; then
      unzip -o algiz-dotfiles-laptop.zip -d /home/$USER/
      unzip -o algiz-root-main.zip -d /
    fi

    ### LAST COMMANDS ###

    # RESET PERMISSIONS
    reset-permissions

    # APPLY THEME TO CURRENT SESSION
    xfsettingsd -r
    xfwm4 --replace &
    xfce4-panel -r
    xfdesktop --reload

    # CLEANUP
    cd /
    rm -rf /home/algiz-files/
    echo -e "\e[1mAlgiz Theme dotfiles have been successfully extracted\e[0m"
    reboot
fi
'
