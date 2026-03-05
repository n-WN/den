{
  pkgs,
  root,
  lib,
}:
let
  inherit (root.pkgs)
    player-metadata
    powermenu
    ;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  desktopPreset = import ../../../lib/desktop-presets.nix { inherit lib; };
  selected = desktopPreset.selected;
  selectedModules = lib.unique (
    selected.waybar.modulesLeft
    ++ selected.waybar.modulesCenter
    ++ selected.waybar.modulesRight
  );
  hasModule = name: builtins.elem name selectedModules;
  playerctl-has-metadata = lib.getExe (
    pkgs.writeShellScriptBin "playerctl-has-metadata" ''
      ${lib.getExe pkgs.playerctl} metadata >/dev/null 2>&1
    ''
  );
in
[
  (
    {
      "layer" = "top";
      "position" = "top";
      "height" = 40;
      "spacing" = 0;
      "fixed-center" = true;
      "reload_style_on_change" = true;
      "margin-top" = 8;
      "margin-left" = 12;
      "margin-right" = 12;
      "modules-left" = selected.waybar.modulesLeft;
      "modules-center" = selected.waybar.modulesCenter;
      "modules-right" = selected.waybar.modulesRight;
    }
    // lib.optionalAttrs (hasModule "hyprland/window") {
      "hyprland/window" = {
        "max-length" = 72;
        "separate-outputs" = true;
        "rewrite" = {
          "(.*) - Mozilla Firefox" = "$1";
          "(.*) - Chromium" = "$1";
          "(.*) - Brave" = "$1";
        };
      };
    }
    // lib.optionalAttrs (hasModule "hyprland/workspaces") {
      "hyprland/workspaces" = {
        "disable-scroll" = true;
        "format" = "{icon}";
        "sort-by-number" = true;
        "format-icons" = selected.waybar.workspaceIcons;
      };
    }
    // lib.optionalAttrs (hasModule "sway/workspaces") {
      "sway/workspaces" = {
        "disable-scroll" = true;
        "format" = "{icon}";
        "all-outputs" = true;
        "format-icons" = selected.waybar.workspaceIcons;
      };
    }
    // lib.optionalAttrs (hasModule "idle_inhibitor") {
      "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
          "activated" = "󰥔";
          "deactivated" = "";
        };
        "tooltip" = false;
      };
    }
    // lib.optionalAttrs (hasModule "custom/launcher") {
      "custom/launcher" = {
        "format" = "";
        "tooltip" = false;
        "on-click" = lib.getExe' pkgs.kickoff "kickoff";
      };
    }
    // lib.optionalAttrs (hasModule "custom/power") {
      "custom/power" = {
        "format" = "";
        "tooltip" = false;
        "on-click" = lib.getExe powermenu;
      };
    }
    // lib.optionalAttrs (hasModule "backlight") {
      "backlight" = {
        "device" = "apple-panel-bl";
        "on-scroll-up" = "${brightnessctl} s 1%-";
        "on-scroll-down" = "${brightnessctl} s +1%";
        "format" = "{icon} {percent}%";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
    }
    // lib.optionalAttrs (hasModule "bluetooth") {
      "bluetooth" = {
        "format" = "󰂯";
        "format-disabled" = "󰂲";
        "format-connected" = "󰂱";
        "format-connected-battery" = "󰂱 {device_battery_percentage}%";
        "tooltip-format" = "{controller_alias}";
        "tooltip-format-disabled" = "Bluetooth off";
        "tooltip-format-connected" = "{num_connections} connected\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}";
        "tooltip-format-enumerate-connected-battery" = "{device_alias} ({device_battery_percentage}%)";
      };
    }
    // lib.optionalAttrs (hasModule "pulseaudio") {
      "pulseaudio" = {
        "format" = "{icon} {volume}%";
        "format-muted" = "󰝟";
        "format-bluetooth" = "{icon} {volume}%";
        "format-bluetooth-muted" = "󰝟 ";
        "max-volume" = 200;
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [
            ""
            ""
            ""
          ];
        };
        "states" = {
          "warning" = 85;
        };
        "scroll-step" = 1;
        "on-click" = lib.getExe pkgs.pwvucontrol;
        "tooltip" = false;
      };
    }
    // lib.optionalAttrs (hasModule "clock") {
      "clock" = {
        "interval" = 1;
        "format" = " {:%H:%M}";
        "format-alt" = " {:%m-%d %a}";
        "tooltip" = true;
        "today-format" = "<span color='#ff6699'><b>{}</b></span>";
        "tooltip-format" = ''
          {:%A %B %Y}
          <tt>{calendar}</tt>'';
      };
    }
    // lib.optionalAttrs (hasModule "battery") {
      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon} {capacity}%";
        "format-full" = "{icon} {capacity}%";
        "format-charging" = "󰂄 {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-alt" = "{icon} {time}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
    }
    // lib.optionalAttrs (hasModule "cpu") {
      "cpu" = {
        "interval" = 2;
        "format" = " {usage}%";
      };
    }
    // lib.optionalAttrs (hasModule "memory") {
      "memory" = {
        "interval" = 2;
        "format" = "󰍛 {}%";
      };
    }
    // lib.optionalAttrs (hasModule "custom/music") {
      "custom/music" = {
        "format" = " {}";
        "interval" = 1;
        "max-length" = 38;
        "exec-if" = playerctl-has-metadata;
        "exec" = "${player-metadata}";
        "on-click" = "${lib.getExe pkgs.playerctl} play-pause";
        "on-click-right" = "${lib.getExe pkgs.playerctl} next";
      };
    }
    // lib.optionalAttrs (hasModule "network") {
      "network" = {
        "interval" = 2;
        "format-wifi" = "{icon} {signalStrength}%";
        "format-icons" = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        "format-ethernet" = "󰈀";
        "format-linked" = "󰈀";
        "format-disconnected" = "󰖪";
        "tooltip" = true;
        "tooltip-format" = ''
          Network: <b>{ifname}</b>
          IP: <b>{ipaddr}/{cidr}</b>
          Gateway: <b>{gwaddr}</b>
        '';
        "tooltip-format-disconnected" = "Disconnected";
      };
    }
    // lib.optionalAttrs (hasModule "tray") {
      "tray" = {
        "icon-size" = 16;
        "spacing" = 5;
      };
    }
  )
]
