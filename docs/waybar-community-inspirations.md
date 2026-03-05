# Waybar Community Inspirations

This setup borrows practical patterns from active open-source Hyprland/Waybar projects,
then adapts them to the local Nix/Home-Manager config.

## Sources

- ML4W dotfiles: module layout and practical icon conventions
  - https://github.com/mylinuxforwork/dotfiles
- Hyprdots: icon semantics for power, network, audio, and utility modules
  - https://github.com/prasanthrangan/hyprdots
- Catppuccin Waybar: consistent palette approach
  - https://github.com/catppuccin/waybar

## Adapted Patterns

- Kept launcher/workspaces/window on the left/center to maintain strong focus flow.
- Switched to semantic icons for audio/network/power (easy visual scan).
- Added memory module to pair with CPU for balanced resource visibility.
- Added explicit power module (``) for direct shutdown menu access.
- Kept old style archived as `legacy` preset for one-line rollback.
