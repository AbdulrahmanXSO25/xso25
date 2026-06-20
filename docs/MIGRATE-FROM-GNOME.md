# Switching from GNOME to Niri

I used GNOME for years. It works. But if you want something that stays out of your way instead of fighting you with extensions, Niri is worth trying.

## What changes

In GNOME you drag windows around. In Niri, they tile automatically in columns.

In GNOME you have a fixed number of workspaces. In Niri, you scroll and more appear.

In GNOME you press Super to search. In Niri, you press Super+Space for rofi.

The big difference: Niri doesn't float windows by default. Most things tile. You can float when needed, but tiling is faster once you get used to it.

## Installing

```bash
# Switch from GDM to SDDM
sudo systemctl disable gdm
sudo pacman -S sddm
sudo systemctl enable sddm

# Run the xso25 installer
bash <(curl -s https://raw.githubusercontent.com/AbdulrahmanXSO25/xso25/main/install.sh)
```

## Your GNOME apps still work

Niri doesn't uninstall anything. Nautilus, Calculator, Text Editor, Evince — they all run fine. The only thing you lose is the GNOME Shell itself.

**Stuff that still works:** Nautilus, GNOME apps, Firefox, Chrome, VS Code, Steam, Discord, everything that isn't a GNOME Shell extension.

**Stuff that won't work:** GNOME Shell extensions, GNOME Settings (config files replace it), GDM (replaced by SDDM).

## Shortcuts you already know

| Action | GNOME | xso25 |
|--------|-------|-------|
| Open terminal | Super+T | Super+Return |
| Close window | Alt+F4 | Super+Q |
| Switch workspace | Super+PageUp/Down | Super+U/I |
| Lock screen | Super+L | Super+Alt+L |
| Screenshot | Print | Print |
| Open files | Super+E | Super+E |

## Going back

```bash
sudo systemctl disable sddm
sudo systemctl enable gdm
sudo reboot
```

Pick GNOME from the login screen. Your old session is still there.
