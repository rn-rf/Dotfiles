# Check if run as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo"
    exit 1
fi

# Pacman packages
packages=(
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
sudo pacman -Syu --noconfirm

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
    zen-browser-bin
)

# checking yay installed
if ! command -v yay &> /dev/null; then
    cd /tmp || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --confirm
fi

echo "Installing AUR packages..."
for pkg in "${aur[@]}"; do
    echo "Installing $pkg..."
    yay -S --noconfirm --needed "$pkg" || {
        echo "Failed to install $pkg"
        exit 1
    }
done
echo "All AUR packages intalled successfully!"


# linking dotfiles to .config
ln -s ~/Dotfiles/hypr ~/.config/hypr
ln -s ~/Dotfiles/waybar ~/.config/waybar
ln -s ~/Dotfiles/ghostty ~/.config/ghostty

# installing custom script
SRC_DIR="$HOME/Dotfiles/custom"
DEST_DIR="/usr/local/bin"

# Copy scripts and set permissions
for script in "$SRC_DIR"/*; do
    if [[ -f "$script" ]]; then
        cp "$script" "$DEST_DIR"
        chmod +x "$DEST_DIR/$(basename "$script")"
        echo "Installed $(basename "$script")"
    fi
done
echo "All scripts installed successfully."


