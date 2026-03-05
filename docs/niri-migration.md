# Niri Migration Notes

## Why Move From Sway To Niri

- Scrollable tiling columns: each workspace can hold many columns and scroll horizontally.
- Better multi-window-per-column workflow than fixed split trees.
- Dynamic workspace flow: fast move/focus between workspaces without deep tree juggling.
- Native config validation in CI/build pipeline via `niri validate`.
- Built-in IPC (`niri msg`) for output/workspace automation.

## Current Migration State

- NixOS module switched to `inputs.niri.nixosModules.niri`.
- `programs.niri.enable = true` at system level.
- Sway disabled in both NixOS and Home Manager.
- TTY autologin shell now launches `niri` instead of `sway`.
- Waybar moved from `sway/*` modules to `niri/*` modules.
- X11 bridge handled by `services.xwayland-satellite` user service tied to `niri.service`.

## Keybinding Mapping (Sway -> Niri)

- `Mod+Return`: terminal
- `Mod+O`: launcher
- `Mod+H/J/K/L`: focus navigation
- `Mod+Shift+H/J/K/L`: move navigation
- `Mod+Shift+Q`: close window
- `Mod+F`: maximize column
- `Mod+Shift+F`: fullscreen window
- `Mod+1..9`: focus workspace
- `Mod+Shift+1..9`: move window to workspace

## Operational Differences

- Sway tree commands (`focus left/right`, `move left/right`) become niri column/window actions.
- Scratchpad workflow is not carried over by default; replace with workspace-based flow.
- Output scaling automation is kept via `niri msg output ... scale ...`.

## Rollback

- Re-enable `programs.sway.enable`.
- Disable `programs.niri.enable`.
- Switch fish TTY launcher back to `exec sway`.
- Restore Waybar `sway/*` modules.
