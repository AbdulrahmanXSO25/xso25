#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
# xso25 — Niri Rice Installer
# ═══════════════════════════════════════════════════════════════════════
# Installs xso25 dotfiles for Niri scrollable-tiling Wayland compositor.
# Usage: bash <(curl -s https://raw.githubusercontent.com/YOUR_USER/xso25/main/install.sh)
# ═══════════════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║          xso25 — Niri Rice Installer         ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ── Check system ──
echo -e "${YELLOW}:: Checking system...${NC}"
if [ "$(uname)" != "Linux" ]; then
    echo -e "${RED}This installer is for Linux only.${NC}"
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    echo -e "${RED}This installer requires Arch Linux (pacman).${NC}"
    exit 1
fi

# ── Install packages ──
echo -e "${YELLOW}:: Installing required packages...${NC}"
sudo pacman -S --needed --noconfirm \
    niri \
    waybar \
    alacritty \
    swaync \
    wlogout \
    rofi \
    swaylock \
    swayidle \
    swaybg \
    cliphist \
    wl-clipboard \
    brightnessctl \
    playerctl \
    pipewire \
    wireplumber \
    polkit-gnome \
    imagemagick \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd \
    otf-font-awesome

# Check for AUR helper
AUR_HELPER=""
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
fi

if [ -n "$AUR_HELPER" ]; then
    echo -e "${YELLOW}:: Installing AUR packages...${NC}"
    $AUR_HELPER -S --needed --noconfirm \
        xwayland-satellite 2>/dev/null || true
fi

# ── Backup existing configs ──
echo -e "${YELLOW}:: Backing up existing configs...${NC}"
BACKUP_DIR="$HOME/.config/xso25-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
for dir in niri foot swaync swaylock xso25; do
    [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
done
echo -e "${GREEN}  → Backup saved to $BACKUP_DIR${NC}"

# ── Copy configs ──
echo -e "${YELLOW}:: Installing xso25 configs...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create config directories
mkdir -p "$HOME/.config/niri"
mkdir -p "$HOME/.config/foot"
mkdir -p "$HOME/.config/swaync"
mkdir -p "$HOME/.config/swaylock"
mkdir -p "$HOME/.config/xso25/bin"
mkdir -p "$HOME/.config/environment.d"
mkdir -p "$HOME/Pictures/Wallpapers"

# Copy files
cp -r "$SCRIPT_DIR/.config/niri/"* "$HOME/.config/niri/"
cp -r "$SCRIPT_DIR/.config/foot/"* "$HOME/.config/foot/"
cp -r "$SCRIPT_DIR/.config/swaync/"* "$HOME/.config/swaync/"
cp -r "$SCRIPT_DIR/.config/swaylock/"* "$HOME/.config/swaylock/"
cp -r "$SCRIPT_DIR/.config/xso25/"* "$HOME/.config/xso25/"
cp -r "$SCRIPT_DIR/.config/environment.d/"* "$HOME/.config/environment.d/"

# Copy wallpaper
if [ -f "$SCRIPT_DIR/assets/wallpapers/default.jpg" ]; then
    cp "$SCRIPT_DIR/assets/wallpapers/default.jpg" "$HOME/Pictures/Wallpapers/"
fi

# Set permissions
chmod +x "$HOME/.config/xso25/bin/"*
chmod +x "$HOME/.config/niri/startup.sh"

# ── Set up environment ──
echo -e "${YELLOW}:: Setting up environment...${NC}"
mkdir -p "$HOME/.config/environment.d"
cp "$SCRIPT_DIR/.config/environment.d/niri.conf" "$HOME/.config/environment.d/"

echo ""
echo -e "${GREEN}  ✅ Installation complete!${NC}"
echo ""
echo "  ─────────────────────────────────────────────"
echo "  Next steps:"
echo "  1. Log out of your current session"
echo "  2. Select 'Niri' from SDDM session menu"
echo "  3. Log in and enjoy xso25"
echo ""
echo "  Optional:"
echo "  • Install xwayland-satellite for X11 apps"
echo "  • Install swww for animated wallpapers"
echo "  ─────────────────────────────────────────────"
echo ""
echo -e "${BLUE}  xso25 — Niri, riced.${NC}"
