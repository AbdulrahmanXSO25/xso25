# Installing xso25 from scratch

For people sitting at a terminal with no desktop yet.

## What you need

- Arch Linux or Fedora 40+
- Internet connection
- `git` and `curl` (install them if needed)

## The install

```bash
bash <(curl -s https://raw.githubusercontent.com/AbdulrahmanXSO25/xso25/main/install.sh)
```

The installer does this:

1. Detects your distro and GPU
2. Installs GPU drivers (AMD, Intel, or NVIDIA)
3. Installs Wayland, PipeWire, and SDDM
4. Installs Niri, waybar, alacritty, rofi, and everything else
5. Copies the xso25 configs (backs up your existing ones first)
6. Enables SDDM, NetworkManager, and bluetooth

## After installing

```bash
sudo reboot
```

When your computer boots, you'll see SDDM. Before typing your password, click the session selector (gear icon) and pick **Niri**. Log in.

## Troubleshooting

**Niri doesn't show up in the session menu.** Check if the session file exists:

```bash
ls /usr/share/wayland-sessions/niri.desktop
```

If it's missing, reinstall Niri: `sudo pacman -S niri`.

**Black screen after login.** Switch to another TTY with `Ctrl+Alt+F2` and check the logs:

```bash
journalctl -xe | grep niri
```

**No sound.** Restart audio:

```bash
systemctl --user restart pipewire wireplumber
```

**No internet.** Connect with:

```bash
nmcli device wifi connect "NetworkName" password "password"
```

**Want your old desktop back?** Pick it from the SDDM session menu. Both are still installed.
