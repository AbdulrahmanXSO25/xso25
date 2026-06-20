#!/usr/bin/env bash
# Niri Startup Script — Migrated from ML4W Hyprland autostart
# This replaces ~/.config/hypr/conf/autostart.conf functionality
# without hyprctl dependencies.

set -e

# ── Source environment ──
# shellcheck source=/dev/null
[ -f ~/.config/niri/env.sh ] && . ~/.config/niri/env.sh

# ── Set Wallpaper (clear, terminal blur is handled by compositor) ──
WALLPAPER="$HOME/Downloads/my-bg.jpg"
if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER=$(find "$HOME/Pictures/Wallpapers" -type f \( -name '*.jpg' -o -name '*.png' \) 2>/dev/null | shuf -n 1)
fi
if [ -n "$WALLPAPER" ] && command -v swaybg &>/dev/null; then
    killall swaybg 2>/dev/null || true
    swaybg -i "$WALLPAPER" -m fill &>/dev/null &
fi

# ── Clipboard History ──
# Start cliphist listener (replaces hyprctl dependency)
if command -v wl-paste &>/dev/null && command -v cliphist &>/dev/null; then
    wl-paste --watch cliphist store 2>/dev/null &
fi

# ── Polkit Authentication Agent ──
if ! pgrep -x polkit-gnome-au >/dev/null; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

# ── Swayidle (idle daemon) ──
if command -v swayidle &>/dev/null && command -v swaylock &>/dev/null; then
    pkill swayidle 2>/dev/null || true
    swayidle -w \
        timeout 300 'swaylock -f -c 111418' \
        timeout 600 'swaylock -f -c 000000' \
        before-sleep 'swaylock -f -c 111418' &
fi

# ── Nm-applet (NetworkManager applet) ──
if command -v nm-applet &>/dev/null; then
    nm-applet --indicator 2>/dev/null &
fi

# ── Blueman Applet (Bluetooth tray) ──
if command -v blueman-applet &>/dev/null; then
    blueman-applet 2>/dev/null &
fi

# ── Set cursor theme for XWayland ──
if command -v xsetroot &>/dev/null; then
    xsetroot -cursor_name left_ptr 2>/dev/null || true
fi

echo "Niri startup script completed at $(date)"
