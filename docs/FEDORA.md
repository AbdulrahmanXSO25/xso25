# xso25 on Fedora

The installer works on Fedora 40+. It handles package name differences automatically.

```bash
bash <(curl -s https://raw.githubusercontent.com/AbdulrahmanXSO25/xso25/main/install.sh)
```

## What the installer does differently on Fedora

- Uses `SwayNotificationCenter` instead of `swaync`
- Uses `rofi-wayland` instead of `rofi`
- Uses `lxpolkit` instead of `polkit-gnome`
- Uses `fontawesome-6-free-fonts` + `fontawesome-fonts-all` instead of `otf-font-awesome`
- Builds `cliphist` from source (not in Fedora repos)
- Patches the waybar update button to use `sudo dnf upgrade`
- Doesn't install `xwayland-satellite` (not available on Fedora)

## Package equivalents

| Arch | Fedora |
|------|--------|
| `swaync` | `SwayNotificationCenter` |
| `rofi` | `rofi-wayland` |
| `polkit-gnome` | `lxpolkit` |
| `otf-font-awesome` | `fontawesome-6-free-fonts` + `fontawesome-fonts-all` |
| `imagemagick` | `ImageMagick` |
| `ttf-jetbrains-mono-nerd` | `jetbrains-mono-fonts` |
| `ttf-firacode-nerd` | `fira-code-fonts` |
| `noto-fonts-emoji` | `google-noto-emoji-fonts` |
| `cliphist` | *(built from source)* |

Everything else (`niri`, `waybar`, `alacritty`, `foot`, `wlogout`, `swaylock`, etc.) is the same name.

## After install

Reboot and select **Niri** from the SDDM session menu.

## Known Fedora differences

- **Battery adapter** may be `AC` instead of `ADP0`. If battery doesn't show in waybar, edit `~/.config/niri/waybar-config.jsonc` and change `"adapter": "ADP0"` to `"adapter": "AC"`.
- **Power profiles** module in waybar may not work due to package conflicts. If errors appear, remove `"power-profiles-daemon"` from the right-side modules in `waybar-config.jsonc`.
- **SELinux**: if things act weird, run `sudo ausearch -m avc -ts recent` to check for denials. If `mmap` denials appear: `sudo setsebool -P domain_can_mmap_files 1`.
