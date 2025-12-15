#!/usr/bin/env bash
set -e

echo "Starting post-install setup..."

# Update System
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install pacman packages
if [ -f pkglist.txt ]; then
    echo "Installing packages..."
    sudo pacman -S --needed --noconfirm $(grep -vE '^\s*#' pkglist.txt | tr '\n' ' ')
fi

# Install paru and AUR packages
if ! command -v paru &>/dev/null; then
    echo "Installing paru..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
fi

if [ -f pkglist-aur.txt ]; then
    echo "Installing AUR packages..."
    paru -S --needed --noconfirm $(grep -vE '^\s*#' pkglist-aur.txt | tr '\n' ' ')
fi

# Manage kitty config
echo "Installing kitty config..."
KITTY_CONFIG_DIR="$HOME/.config/kitty"
mkdir -p "$KITTY_CONFIG_DIR"

if [ -f "$KITTY_CONFIG_DIR/kitty.conf" ]; then
    echo "Backing up existing kitty.conf"
    mv "$KITTY_CONFIG_DIR/kitty.conf" "$KITTY_CONFIG_DIR/kitty.conf.bak"
fi

cp dotfiles/kitty.conf "$KITTY_CONFIG_DIR/kitty.conf"
echo "Kitty config installed!"

# SDDM theme
THEME_TAR="sddm/TerminalStyleLogin.tar.gz"
THEME_NAME="TerminalStyleLogin"

if [ -f "$THEME_TAR" ]; then
    echo "Installing SDDM theme..."
    tar -xvf "$THEME_TAR" -C /tmp/
    sudo mv "/tmp/$THEME_NAME" /usr/share/sddm/themes/
    if ! grep -q "^Current=$THEME_NAME" /etc/sddm.conf 2>/dev/null; then
        echo "[Theme]" | sudo tee -a /etc/sddm.conf
        echo "Current=$THEME_NAME" | sudo tee -a /etc/sddm.conf
    fi
    echo "SDDM theme installed. Restart SDDM manually to apply."
else
    echo "Theme not found!"
fi

# Wallpapers

WALLS_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLS_DIR"
cp -r walls/* "$WALLS_DIR/"
echo "Wallpapers copied to $WALLS_DIR"

# Enable system services

echo "Enabling system services..."
sudo systemctl enable NetworkManager
sudo systemctl enable sddm

echo "==> Setup complete!"
echo "==> Remember to manually restart SDDM to apply your theme."
