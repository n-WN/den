# Desktop Presets (Hyprland + Waybar)

This repo now uses a single preset switch for both:

- status bar (Waybar modules + style)
- desktop main page look (wallpaper, Firefox startup page, border color)

## Active Preset

Edit one value in:

- `lib/desktop-presets.nix`

```nix
activePreset = "aurora";
```

Available presets:

- `legacy`: archived old look before this preset system
- `aurora`: refreshed Hyprland-first look

## What Each Preset Controls

- `waybar.style` -> CSS file name under `lib/waybar-presets/`
- `waybar.modulesLeft/modulesCenter/modulesRight` -> visible modules
- `desktop.wallpaper` -> wallpaper key resolved in Hyprland config
- `desktop.startupPage` -> Firefox startup page on login
- `desktop.activeBorder/inactiveBorder` -> Hyprland border colors

## Archive Guarantee

The original bar theme is archived at:

- `lib/waybar-presets/legacy.css`

So rollback is always one-line (`activePreset = "legacy"`).
