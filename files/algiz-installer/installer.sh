#!/bin/bash

su -c '
### ALGIZ THEME CHOICE SELECTION ###

echo -e "\e[1mSelect a Algiz Theme Variant\e[0m"
echo "1. DESKTOP"
echo "2. LAPTOP"

read -p "Enter your choice (1-2): " choice

# DOWNLOAD BASE PACKAGES
pacman -S --noconfirm unzip git || true

### CLONE ALGIZ THEME FILES ###

echo -e "\e[1mCloning Algiz Theme files...\e[0m"
mkdir -p /home/algiz-files/
git clone https://github.com/Michael-Sebero/Algiz-Theme /home/algiz-files/
cd /home/algiz-files/files/algiz-packages/

### REMOVE OLD XFCE DIRECTORIES ###

echo -e "\e[1mRemoving old xfce directories from /home/$USER...\e[0m"
find /home/$USER -maxdepth 1 -type d -iname "*xfce*" -exec rm -rf {} + || true

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

### XFCE ###

HAS_THUNAR=0
if pacman -Qq | grep -q "^thunar$"; then
    HAS_THUNAR=1
    pacman -Sy --noconfirm mugshot xfce4-panel-profiles lightdm-gtk-greeter-settings artix-dark-theme || true
fi

### RESET PERMISSIONS ###
# Runs regardless of the thunar check and regardless of pacman succeeding.
# Everything above was unzipped as root, so ownership/permissions must be fixed.
# Called by absolute path because su -c keeps the calling users PATH.

echo -e "\e[1mRunning reset-permissions...\e[0m"
RESET_PERMS=""
for p in /usr/bin/reset-permissions /bin/reset-permissions; do
  if [ -f "$p" ]; then
    RESET_PERMS="$p"
    break
  fi
done

if [ -n "$RESET_PERMS" ]; then
  chmod 755 "$RESET_PERMS"
  bash "$RESET_PERMS" || echo "WARNING: reset-permissions exited with an error"
else
  echo "WARNING: reset-permissions not found - algiz-root-main.zip may not have extracted"
fi

### APPLY THEME TO CURRENT SESSION ###

if [ "$HAS_THUNAR" = "1" ]; then
    xfsettingsd -r
    xfwm4 --replace &
    xfce4-panel -r
    xfdesktop --reload
fi

### CLEANUP ###

cd /
rm -rf /home/algiz-files/
echo -e "\e[1mAlgiz Theme dotfiles have been successfully extracted\e[0m"
reboot
'
