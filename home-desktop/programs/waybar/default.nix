{ lib }:
let
  desktopPreset = import ../../../lib/desktop-presets.nix { inherit lib; };
  selected = desktopPreset.selected;
in
{
  enable = true;
  style = builtins.readFile "${./presets}/${selected.waybar.style}.css";
  systemd.enable = true;
}
