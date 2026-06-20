#!/usr/bin/env bash
# Niri Environment Variables — Migrated from Hyprland
# Source this in your startup scripts or session wrapper.
# For systemd user environment, also add these to ~/.config/environment.d/niri.conf

export XDG_CURRENT_DESKTOP="niri"
export XDG_SESSION_DESKTOP="niri"
export XDG_SESSION_TYPE="wayland"

# Qt
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
export QT_AUTO_SCREEN_SCALE_FACTOR="1"

# GDK (GTK)
export GDK_BACKEND="wayland,x11,*"

# Clutter
export CLUTTER_BACKEND="wayland"

# Mozilla (Firefox)
export MOZ_ENABLE_WAYLAND="1"

# Ozone (Electron/Chromium)
export OZONE_PLATFORM="wayland"
export ELECTRON_OZONE_PLATFORM_HINT="wayland"

# SDL2
export SDL_VIDEODRIVER="wayland"

# Cursor
export XCURSOR_SIZE="24"

# Java
export _JAVA_AWT_WM_NONREPARENTING="1"

# Niri specific
export NIRI_INSTANCE_SIGNATURE=""
