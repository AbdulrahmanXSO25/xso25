# xso25 on Fedora

The installer works on Fedora 40+. Package names differ from Arch, so here's what you need to know.

## Quick way

Run the same command:

```bash
bash <(curl -s https://raw.githubusercontent.com/AbdulrahmanXSO25/xso25/main/install.sh)
```

The installer handles Fedora differences automatically — correct package names, cliphist build, SELinux, and the right update command for dnf.

## Package names

| Arch | Fedora |
|------|--------|
| `swaync` | `SwayNotificationCenter` |
| `rofi` | `rofi-wayland` |
| `imagemagick` | `ImageMagick` |
| `ttf-jetbrains-mono-nerd` | `jetbrains-mono-fonts` |
| `ttf-firacode-nerd` | `fira-code-fonts` |
| `otf-font-awesome` | `fontawesome-fonts` |
| `noto-fonts-emoji` | `google-noto-emoji-fonts` |
| `cliphist` | *(build from source)* |

Everything else (`niri`, `waybar`, `alacritty`, `wlogout`, `swaylock`, etc.) is the same name.

## SELinux

If something acts weird, SELinux might be blocking it. Check for denials:

```bash
sudo ausearch -m avc -ts recent
```

If you see `mmap` denials:

```bash
sudo setsebool -P domain_can_mmap_files 1
```

Only poke at SELinux if something is actually broken.
