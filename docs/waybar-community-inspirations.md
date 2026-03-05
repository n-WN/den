# Waybar Community Inspirations

This setup borrows practical patterns from active open-source Hyprland/Waybar projects,
then adapts them to the local Nix/Home-Manager config.

## Sources

- Hyprdots: grouped module layout, stronger workspace active state, compact utility icons
  - https://github.com/prasanthrangan/hyprdots
- JaKooLit Hyprland Dots: modular top bar compositions, bright activation treatment
  - https://github.com/JaKooLit/Hyprland-Dots
- XNM1 NixOS Hyprland config: clean split-container bar layout and Bluetooth/network semantics
  - https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles
- gvolpe nix-config: restrained workspace icon mapping and low-noise Hyprland bar composition
  - https://github.com/gvolpe/nix-config

## Adapted Patterns

- `aurora` keeps a three-zone bar with left focus flow, centered window title, and a compact status cluster on the right.
- Workspace buttons now rely on CSS-driven active styling instead of hardcoded per-icon colors, so the focused workspace reads immediately.
- Right-side status uses quieter iconography with tooltips carrying the verbose details.
- Bluetooth was added because it is a common Hyprland community status module and the host already enables Bluetooth.
- The original bar remains archived as `legacy` for a one-line rollback.
