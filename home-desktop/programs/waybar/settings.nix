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
  playerctl-has-metadata = lib.getExe (
    pkgs.writeShellScriptBin "playerctl-has-metadata" ''
      ${lib.getExe pkgs.playerctl} metadata >/dev/null 2>&1
    ''
  );
in
[
  {
    "layer" = "top";
    "position" = "top";
    "modules-left" = selected.waybar.modulesLeft;
    "modules-center" = selected.waybar.modulesCenter;
    "modules-right" = selected.waybar.modulesRight;
    "hyprland/window" = {
      "max-length" = 72;
      "separate-outputs" = true;
      "rewrite" = {
        "(.*) - Mozilla Firefox" = "$1";
        "(.*) - Chromium" = "$1";
        "(.*) - Brave" = "$1";
      };
    };
    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "format" = "{icon}";
      "sort-by-number" = true;
      "format-icons" = {
        "1" = ''<span color="#FF7139"></span>'';
        "2" = ''<span color="#757575"></span>'';
        "3" = ''<span color="#26A5E4"></span>'';
        "4" = ''<span color="#0A84FF"></span>'';
      };
    };
    "sway/workspaces" = {
      "disable-scroll" = true;
      "format" = "{icon}";
      "all-outputs" = true;
      "format-icons" = {
        "1" = ''<span color="#FF7139"></span>'';
        "2" = ''<span color="#757575"></span>'';
        "3" = ''<span color="#26A5E4"></span>'';
        "4" = ''<span color="#0A84FF"></span>'';
      };
    };
    "idle_inhibitor" = {
      "format" = "{icon}";
      "format-icons" = {
        "activated" = "󰥔";
        "deactivated" = "";
      };
      "tooltip" = false;
    };
    "custom/launcher" = {
      "format" = "";
      "tooltip" = false;
      "on-click" = lib.getExe' pkgs.kickoff "kickoff";
    };
    "custom/power" = {
      "format" = "";
      "tooltip" = false;
      "on-click" = lib.getExe powermenu;
    };
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
      "on-click" = "${lib.getExe pkgs.pwvucontrol}";
      "tooltip" = false;
    };
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
    "cpu" = {
      "interval" = 1;
      "format" = " {usage}%";
    };
    "memory" = {
      "interval" = 2;
      "format" = "󰍛 {}%";
    };
    "custom/music" = {
      "format" = " {}";
      "interval" = 1;
      "exec-if" = playerctl-has-metadata;
      "exec" = "${player-metadata}";
    };
    "network" = {
      "interval" = 2;
      "format-wifi" = " {signalStrength}%";
      "format-ethernet" = "󰈀 {ipaddr}";
      "format-linked" = "󰈀 {ifname}";
      "format-disconnected" = "󰖪";
      "tooltip" = true;
      "tooltip-format" = ''
        Network: <b>{ifname}</b>
        IP: <b>{ipaddr}/{cidr}</b>
        Gateway: <b>{gwaddr}</b>
      '';
      "tooltip-format-disconnected" = "Disconnected";
    };
    "tray" = {
      "icon-size" = 16;
      "spacing" = 5;
    };
  }
]
