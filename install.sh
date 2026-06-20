#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
# xso25 — Niri Rice Installer
# ═══════════════════════════════════════════════════════════════════════
# Installs the entire stack: GPU drivers → Wayland → DM → Niri → rice
# Supports: Arch Linux (pacman), Fedora 40+ (dnf)
# ═══════════════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${BLUE}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║            xso25 — Niri Rice Installer              ║"
echo "  ║  Installs full stack: GPU → Wayland → DM → Niri    ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ──────────────────────────────────────────────────────────────────────
# PHASE 0: Detect system
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[0/5] Detecting system...${NC}"

# Distro detection
DISTRO=""
if command -v pacman &>/dev/null; then DISTRO="arch"; fi
if command -v dnf &>/dev/null; then DISTRO="fedora"; fi

if [ -z "$DISTRO" ]; then
    echo -e "${RED}Unsupported distro. Only Arch Linux and Fedora 40+ are supported.${NC}"
    echo -e "${YELLOW}See docs/ for manual installation guides.${NC}"
    exit 1
fi
echo -e "${GREEN}  → Detected: $DISTRO${NC}"

# Graphics card detection
GPU=""
if lspci 2>/dev/null | grep -qi "nvidia"; then GPU="nvidia"; fi
if lspci 2>/dev/null | grep -qi "amd.*radeon\|amd.*gpu"; then GPU="$GPU amd"; fi
if lspci 2>/dev/null | grep -qi "intel.*graphics\|intel.*hd"; then GPU="$GPU intel"; fi
if [ -z "$GPU" ]; then GPU="unknown"; fi
echo -e "${GREEN}  → Detected GPU(s):$GPU${NC}"

# TTY detection (no display running)
if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
    echo -e "${YELLOW}  → Running in TTY mode (no display detected)${NC}"
    TTY_MODE=true
else
    TTY_MODE=false
fi

# ──────────────────────────────────────────────────────────────────────
# PHASE 1: Base system — GPU drivers + Wayland infrastructure
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[1/5] Installing base system (GPU drivers + Wayland + audio)...${NC}"

BASE_PACKAGES_ARCH=""
BASE_PACKAGES_FEDORA=""

if [ "$DISTRO" = "arch" ]; then
    # Arch: GPU drivers
    if echo "$GPU" | grep -q "amd"; then
        BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH vulkan-radeon libva-mesa-driver mesa-vdpau"
    fi
    if echo "$GPU" | grep -q "intel"; then
        BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH vulkan-intel intel-media-driver"
    fi
    if echo "$GPU" | grep -q "nvidia"; then
        BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings"
        echo -e "${YELLOW}  → NVIDIA detected: nvidia-dkms will be installed.${NC}"
        echo -e "${YELLOW}    For Optimus laptops, also install: optimus-manager or nvidia-prime${NC}"
    fi

    # Wayland infra
    BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH wayland libinput libdisplay-info mesa"

    # Audio
    BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH pipewire pipewire-pulse pipewire-jack wireplumber"

    # Display manager
    BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH sddm"

    # Network (if not present)
    BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH networkmanager network-manager-applet"

    # System tools
    BASE_PACKAGES_ARCH="$BASE_PACKAGES_ARCH polkit-kde-agent xdg-desktop-portal xdg-desktop-portal-gtk"

    sudo pacman -S --needed --noconfirm $BASE_PACKAGES_ARCH

elif [ "$DISTRO" = "fedora" ]; then
    # Fedora: GPU drivers
    if echo "$GPU" | grep -q "amd"; then
        BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA mesa-vulkan-drivers mesa-libva"
    fi
    if echo "$GPU" | grep -q "intel"; then
        BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA mesa-vulkan-drivers intel-media-driver"
    fi
    if echo "$GPU" | grep -q "nvidia"; then
        BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA akmod-nvidia xorg-x11-drv-nvidia-cuda"
        echo -e "${YELLOW}  → NVIDIA detected: akmod-nvidia will be installed.${NC}"
    fi

    # Wayland infra
    BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA wayland libinput mesa-dri-drivers"

    # Audio
    BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA pipewire pipewire-pulseaudio wireplumber"

    # Display manager
    BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA sddm"

    # Network
    BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA NetworkManager NetworkManager-tui"

    # Portal
    BASE_PACKAGES_FEDORA="$BASE_PACKAGES_FEDORA xdg-desktop-portal xdg-desktop-portal-gtk"

    sudo dnf install -y $BASE_PACKAGES_FEDORA
fi

echo -e "${GREEN}  ✅ Base system installed${NC}"

# ──────────────────────────────────────────────────────────────────────
# PHASE 2: Niri + Wayland tools
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[2/5] Installing Niri and Wayland tools...${NC}"

if [ "$DISTRO" = "arch" ]; then
    sudo pacman -S --needed --noconfirm \
        niri \
        waybar \
        alacritty foot \
        swaync wlogout \
        rofi rofi-emoji \
        swaylock swayidle swaybg \
        cliphist wl-clipboard \
        brightnessctl playerctl \
        polkit-gnome imagemagick \
        ttf-jetbrains-mono-nerd ttf-firacode-nerd \
        otf-font-awesome noto-fonts-emoji \
        qalculate-gtk

    # Optional: xwayland-satellite for X11 apps
    if command -v paru &>/dev/null; then
        paru -S --needed --noconfirm xwayland-satellite 2>/dev/null || true
    elif command -v yay &>/dev/null; then
        yay -S --needed --noconfirm xwayland-satellite 2>/dev/null || true
    else
        echo -e "${YELLOW}  → Install paru or yay for AUR packages, or skip:${NC}"
        echo "    xwayland-satellite (X11 app support, recommended)"
    fi

elif [ "$DISTRO" = "fedora" ]; then
    # Try official repo first, fall back to COPR
    if ! dnf info niri &>/dev/null; then
        sudo dnf copr enable -y alebastr/niri 2>/dev/null || true
    fi

    sudo dnf install -y \
        niri waybar alacritty foot \
        SwayNotificationCenter wlogout \
        rofi-wayland \
        swaylock swayidle swaybg \
        wl-clipboard brightnessctl playerctl \
        polkit-gnome ImageMagick \
        jetbrains-mono-fonts fira-code-fonts \
        fontawesome-fonts google-noto-emoji-fonts \
        qalculate-gtk

    # Build cliphist for Fedora
    if ! command -v cliphist &>/dev/null; then
        echo -e "${YELLOW}  → Building cliphist from source...${NC}"
        if command -v go &>/dev/null; then
            go install go.senan.xyz/cliphist@latest
            sudo cp ~/go/bin/cliphist /usr/local/bin/ 2>/dev/null || true
        else
            sudo dnf install -y golang
            go install go.senan.xyz/cliphist@latest
            sudo cp ~/go/bin/cliphist /usr/local/bin/ 2>/dev/null || true
        fi
    fi
fi

echo -e "${GREEN}  ✅ Niri + tools installed${NC}"

# ──────────────────────────────────────────────────────────────────────
# PHASE 3: Enable services
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[3/5] Enabling system services...${NC}"

# Enable SDDM
if systemctl list-unit-files sddm.service &>/dev/null; then
    sudo systemctl enable sddm 2>/dev/null || true
    echo -e "${GREEN}  → SDDM enabled${NC}"
fi

# Enable NetworkManager
if systemctl list-unit-files NetworkManager.service &>/dev/null; then
    sudo systemctl enable NetworkManager 2>/dev/null || true
    echo -e "${GREEN}  → NetworkManager enabled${NC}"
fi

# Enable bluetooth
if systemctl list-unit-files bluetooth.service &>/dev/null; then
    sudo systemctl enable bluetooth 2>/dev/null || true
    echo -e "${GREEN}  → Bluetooth enabled${NC}"
fi

# Enable pipewire user service
if command -v systemctl --user &>/dev/null; then
    systemctl --user enable wireplumber 2>/dev/null || true
    echo -e "${GREEN}  → WirePlumber enabled${NC}"
fi

# Disable GDM if present (conflicts with SDDM)
if systemctl list-unit-files gdm.service &>/dev/null; then
    echo -e "${YELLOW}  → GDM detected — disabling in favor of SDDM${NC}"
    sudo systemctl disable gdm 2>/dev/null || true
fi

echo -e "${GREEN}  ✅ Services configured${NC}"

# ──────────────────────────────────────────────────────────────────────
# PHASE 4: Install xso25 configs
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[4/5] Installing xso25 configs...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup existing configs
BACKUP_DIR="$HOME/.config/xso25-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
for dir in niri foot swaync wlogout swaylock xso25; do
    [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
done
echo -e "${GREEN}  → Backup saved to $BACKUP_DIR${NC}"

# Install configs
mkdir -p "$HOME/.config/niri" "$HOME/.config/foot" "$HOME/.config/swaync"
mkdir -p "$HOME/.config/alacritty" "$HOME/.config/wlogout" "$HOME/.config/swaylock"
mkdir -p "$HOME/.config/xso25/bin" "$HOME/.config/environment.d"
mkdir -p "$HOME/Pictures/Wallpapers"

for dir in niri foot swaync wlogout swaylock xso25 environment.d; do
    if [ -d "$SCRIPT_DIR/.config/$dir" ]; then
        cp -r "$SCRIPT_DIR/.config/$dir/"* "$HOME/.config/$dir/" 2>/dev/null || true
    fi
done

# Copy alacritty config to its own directory
cp "$SCRIPT_DIR/.config/niri/alacritty.toml" "$HOME/.config/alacritty/" 2>/dev/null || true

# Wallpaper
[ -f "$SCRIPT_DIR/assets/wallpapers/default.jpg" ] && \
    cp "$SCRIPT_DIR/assets/wallpapers/default.jpg" "$HOME/Pictures/Wallpapers/"

# Permissions
chmod +x "$HOME/.config/xso25/bin/"* 2>/dev/null || true
chmod +x "$HOME/.config/niri/startup.sh" 2>/dev/null || true

# Fedora: fix update checker and waybar update command
if [ "$DISTRO" = "fedora" ]; then
    # Fix the check-updates script
    if [ -f "$HOME/.config/xso25/bin/check-updates" ]; then
        cat > "$HOME/.config/xso25/bin/check-updates" << 'FEDORA'
#!/usr/bin/env bash
updates=$(sudo dnf check-update -q 2>/dev/null | grep -c ^[a-z0-9])
if [ "$updates" -gt 0 ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "Click: sudo dnf upgrade", "class": "%s"}' "$updates" "$updates" "yellow"
else
    printf '{"text": "0", "alt": "0", "tooltip": "Up to date", "class": "green"}'
fi
FEDORA
        chmod +x "$HOME/.config/xso25/bin/check-updates"
    fi

    # Fix waybar update button: Arch's paru → Fedora's dnf
    if [ -f "$HOME/.config/niri/waybar-config.jsonc" ]; then
        sed -i 's|alacritty -e paru -Syu|alacritty -e sudo dnf upgrade|g' \
            "$HOME/.config/niri/waybar-config.jsonc"
    fi

    # SELinux: only enable booleans if AVC denials are detected
    if command -v ausearch &>/dev/null && command -v grep &>/dev/null; then
        if ausearch -m avc -ts recent 2>/dev/null | grep -q "denied.*mmap"; then
            sudo setsebool -P domain_can_mmap_files 1 2>/dev/null || true
        fi
        if ausearch -m avc -ts recent 2>/dev/null | grep -q "execmod"; then
            sudo setsebool -P selinuxuser_execmod 1 2>/dev/null || true
        fi
    fi
fi

echo -e "${GREEN}  ✅ xso25 configs installed${NC}"

# ──────────────────────────────────────────────────────────────────────
# PHASE 5: Final checks
# ──────────────────────────────────────────────────────────────────────

echo -e "${YELLOW}[5/5] Verifying installation...${NC}"

# Check critical tools
CRITICAL="niri waybar swaync wlogout rofi swaylock swayidle swaybg cliphist wl-paste wpctl"
MISSING=""
for cmd in $CRITICAL; do
    command -v "$cmd" &>/dev/null || MISSING="$MISSING $cmd"
done

if [ -n "$MISSING" ]; then
    echo -e "${RED}  ⚠ Missing tools:$MISSING${NC}"
    echo -e "${YELLOW}  Some features may not work. Install them manually.${NC}"
else
    echo -e "${GREEN}  ✅ All critical tools present${NC}"
fi

# ──────────────────────────────────────────────────────────────────────
# Done
# ──────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BLUE}  ╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}  ║           ✅ Installation Complete!                  ║${NC}"
echo -e "${BLUE}  ╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  ─────────────────────────────────────────────"
echo "  Next steps:"
echo ""
if [ "$TTY_MODE" = true ]; then
    echo "  1. Reboot: sudo reboot"
else
    echo "  1. Log out of your current session"
fi
echo "  2. At SDDM login, select 'Niri'"
echo "  3. Log in and enjoy xso25"
echo ""
echo "  From TTY (no display manager):"
echo "    niri-session"
echo ""
echo "  ─────────────────────────────────────────────"
echo "  Docs:"
echo "    • Fedora setup:    docs/FEDORA.md"
echo "    • GNOME migration: docs/MIGRATE-FROM-GNOME.md"
echo "    • Keybindings:     README.md (full table)"
echo "  ─────────────────────────────────────────────"
echo ""
echo -e "${BLUE}  xso25 — Niri, riced.${NC}"
