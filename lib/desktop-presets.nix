{ lib }:
let
  presets = {
    # Archive of the current desktop look before preset system.
    legacy = {
      name = "legacy";
      description = "Current den desktop look archived as a stable fallback.";

      waybar = {
        style = "legacy";
        workspaceIcons = {
          "1" = ''<span color="#FF7139"></span>'';
          "2" = ''<span color="#757575"></span>'';
          "3" = ''<span color="#26A5E4"></span>'';
          "4" = ''<span color="#0A84FF"></span>'';
        };
        modulesLeft = [
          "hyprland/workspaces"
          "sway/workspaces"
          "custom/music"
        ];
        modulesCenter = [
          "hyprland/window"
          "sway/window"
        ];
        modulesRight = [
          "tray"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "cpu"
          "network"
          "battery"
          "clock"
        ];
      };

      desktop = {
        wallpaper = "and-justice-for-all";
        startupPage = "about:blank";
        activeBorder = "83b6af";
        inactiveBorder = "2b3339";
      };
    };

    # Catppuccin-ish palette + cleaner bar layout.
    aurora = {
      name = "aurora";
      description = "A cleaner Hyprland-first preset with softer colors and clearer modules.";

      waybar = {
        style = "aurora";
        workspaceIcons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "default" = "";
        };
        modulesLeft = [
          "custom/launcher"
          "hyprland/workspaces"
          "custom/music"
        ];
        modulesCenter = [ "hyprland/window" ];
        modulesRight = [
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "idle_inhibitor"
          "clock"
          "tray"
          "custom/power"
        ];
      };

      desktop = {
        wallpaper = "metallica-default";
        startupPage = "https://hypr.land/news";
        activeBorder = "89b4fa";
        inactiveBorder = "313244";
      };
    };
  };

  # Single switch for status bar + desktop main page.
  activePreset = "aurora";

  selected = presets.${activePreset};
in
{
  inherit presets activePreset selected;
}
