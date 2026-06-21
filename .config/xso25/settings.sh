#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
# xso25 — Niri App Settings
# Change these to switch your default apps across the entire desktop.
# ═══════════════════════════════════════════════════════════════════════

export TERMINAL="alacritty"
export BROWSER="firefox"
export FILE_MANAGER="thunar"
export LAUNCHER="rofi -show drun -theme $HOME/.config/niri/rofi-theme.rasi"
export CLIPBOARD="cliphist list | rofi -dmenu -p 'clipboard' | cliphist decode | wl-copy"
export EMOJI_PICKER="rofi -modi emoji -show emoji"
export CALCULATOR="qalculate-gtk"
export EMOJI="rofi -modi emoji -show emoji"
export NOTES=""
