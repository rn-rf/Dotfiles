#!/bin/bash

# Pacman packages
packages=(
    telegram-desktop
    ttf-nerd-fonts-symbols
    tmux
    ntfs-3g
    polkit
    polkit-gnome
    jq
    pamixer
    neovim
    ghostty
    network-manager-applet
    alacritty
    brightnessctl
    git
    imv
    slurp
    thunar
    wofi
    waybar
    blueman
)

echo "Updating package database..."
# sudo pacman -Syu --noconfirm

echo "Installing packages..."
for pkg in "${packages[@]}"; do
    echo "Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg" || {
        echo "Failed to install $pkg"
        exit 1
    }
done
echo "All packages installed successfully!"

# AUR packages
aur=(
    catppuccin-gtk-theme-mocha
    hyprland
    hyprlock
    python-pywal16
    swww
    tela-circle-icon-theme-git
    # zen-browser-bin
)

# checking yay installed
if ! command -v yay &> /dev/null; then
    cd /tmp || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
fi

echo "Installing AUR packages..."
yay -S --noconfirm --needed "${aur[@]}" || {
    echo "Failed to install AUR packages"
    exit 1
}
echo "All AUR packages installed successfully!"

# linking dotfiles to .config
ln -sf ~/Dotfiles/hypr ~/.config/hypr
ln -sf ~/Dotfiles/waybar ~/.config/waybar
ln -sf ~/Dotfiles/ghostty ~/.config/ghostty
ln -sf ~/Dotfiles/assets/Lock-Wallpaper ~/Pictures/Lock-Wallpaper
ln -sf ~/Dotfiles/assets/Wallpaper ~/Pictures/Wallpaper

# installing custom script (needs root)
SRC_DIR="$HOME/Dotfiles/custom"
DEST_DIR="/usr/local/bin"

for script in "$SRC_DIR"/*; do
    if [[ -f "$script" ]]; then
        sudo cp "$script" "$DEST_DIR"
        sudo chmod +x "$DEST_DIR/$(basename "$script")"
        echo "Installed $(basename "$script")"
    fi
done

# Other system setting
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-dark"
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-sapphire-standard+default"
sudo systemctl enable --now polkit

echo "All scripts installed successfully."
