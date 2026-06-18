  ╔══════════════════════════════════════════════╗
  ║          xso25 — Niri, riced.                ║
  ╚══════════════════════════════════════════════╝

A professional Catppuccin Mocha rice for the [Niri](https://github.com/YaLTeR/niri) scrollable-tiling Wayland compositor.

## ✨ Features

- **Catppuccin Mocha** color scheme across all UI elements
- **Glass terminal** with native Wayland blur (Foot)
- **Professional waybar** with grouped modules and visual hierarchy
- **Rofi launcher** matching the theme
- **Wlogout** themed power menu
- **Notification center** with Catppuccin styling
- **Modular app system** — change defaults in one file
- **6 dynamic workspaces** — more appear on demand

## ⚡ Quick Install

```bash
bash <(curl -s https://raw.githubusercontent.com/YOUR_USER/xso25/main/install.sh)
```

Or manually:

```bash
git clone https://github.com/YOUR_USER/xso25.git ~/xso25
cd ~/xso25
./install.sh
```

## 📋 Requirements

| Package | Purpose |
|---------|---------|
| `niri` | Scrollable-tiling Wayland compositor |
| `waybar` | Status bar |
| `alacritty` | Main terminal (GPU-accelerated) |
| `swaync` | Notification daemon |
| `wlogout` | Logout/power menu |
| `rofi` | Application launcher |
| `swaylock` | Screen locker |
| `swayidle` | Idle management |
| `swaybg` | Wallpaper |
| `cliphist` + `wl-clipboard` | Clipboard manager |

Install all with: `sudo pacman -S --needed niri waybar alacritty swaync wlogout rofi swaylock swayidle swaybg cliphist wl-clipboard brightnessctl playerctl pipewire wireplumber polkit-gnome imagemagick ttf-jetbrains-mono-nerd`

## 🎮 Keybindings

### Applications
| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (Alacritty) |
| `Mod+Space` / `Mod+Ctrl+Return` | App launcher (Rofi) |
| `Mod+B` | Browser |
| `Mod+E` | File manager |
| `Mod+Ctrl+E` | Emoji picker |
| `Mod+V` | Clipboard manager |

### Window Management
| Key | Action |
|-----|--------|
| `Mod+Q` / `Mod+W` | Close window |
| `Mod+F` | Fullscreen |
| `Mod+Shift+F` | Maximize column |
| `Mod+Shift+Space` | Toggle floating |
| `Mod+V` | Toggle floating |
| `Mod+Shift+V` | Switch focus floating/tiling |
| `Mod+R` | Cycle column widths |
| `Mod+Shift+R` | Cycle back |

### Focus Movement
| Key | Action |
|-----|--------|
| `Mod+H/J/K/L` | Vim-style focus (left/down/up/right) |
| `Mod+Arrows` | Directional focus |
| `Mod+P` / `Mod+N` | First/last column |

### Workspaces
| Key | Action |
|-----|--------|
| `Mod+1-6` | Switch to workspace 1-6 |
| `Mod+7-0` | Dynamic workspace 7-10 |
| `Mod+Shift+1-0` | Move column to workspace |
| `Mod+U` / `Mod+I` | Previous/next workspace |
| `Mod+Tab` | Previous workspace |

### System
| Key | Action |
|-----|--------|
| `Mod+Escape` | Power menu (wlogout) |
| `Super+Alt+L` | Lock screen |
| `Mod+Shift+E` | Quit Niri |
| `Mod+Shift+W` | Wallpaper selector |
| `Mod+O` | Overview (all workspaces) |
| `Mod+Shift+S` | Screenshot |
| `Print` | Full screenshot |
| `Ctrl+Print` | Screen screenshot |
| `Alt+Print` | Window screenshot |

### Media Keys
| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute |
| `XF86AudioPlay/Next/Prev` | Media control |
| `XF86MonBrightnessUp/Down` | Brightness |

## 🎨 Changing Default Apps

Edit `~/.config/xso25/settings.sh`:

```bash
export TERMINAL="alacritty"   # Change your terminal (foot for glass)
export BROWSER="firefox"      # Change your browser
export FILE_MANAGER="nautilus --new-window"
export LAUNCHER="rofi -show drun -theme ..."
```

## 🧊 Glass Terminal

The glass effect uses:
1. **Alacritty** with `opacity=0.8` for transparency
2. Niri window rule `background-effect { blur true }` for forced blur behind windows
3. `draw-border-with-background false` prevents focus-ring bleed-through
4. **Foot** is available as an alternative with native `blur=true` support

## 📁 Project Structure

```
~/.config/
├── niri/           ← Compositor config + waybar/rofi/wlogout
├── foot/           ← Glass terminal
├── swaync/         ← Notifications
├── swaylock/       ← Lock screen
├── xso25/          ← App system (settings + bin/)
│   ├── settings.sh ← Change your default apps
│   └── bin/        ← App launchers
└── environment.d/  ← Systemd env vars
```

## 📸 Screenshots

*(Add screenshots here)*

## 🧑‍💻 Credits

- [Niri](https://github.com/YaLTeR/niri) — Scrollable-tiling Wayland compositor
- [Catppuccin](https://github.com/catppuccin) — Color scheme
- Inspired by ML4W Hyprland dotfiles

## 📄 License

MIT
