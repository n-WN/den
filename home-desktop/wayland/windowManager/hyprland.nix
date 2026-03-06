{
  lib,
  root,
  pkgs,
  ...
}:
{
  enable = true;
  systemd.enable = true;
  xwayland.enable = true;

  settings =
    let
      inherit (root.pkgs)
        macshot
        powermenu
        recorder-toggle
        swaylock
        ;
      desktopPreset = import ../../../lib/desktop-presets.nix { inherit lib; };
      selected = desktopPreset.selected;
      wallpaper =
        if selected.desktop.wallpaper == "and-justice-for-all" then
          root.pkgs.wallpapers.metallica.and-justice-for-all
        else
          root.pkgs.wallpapers.metallica.default;
      grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
    in
    {
      "$mod" = "SUPER";

      monitor = [
        "DP-1,1920x1080,auto,2"
        "HDMI-A-1,1920x1080,auto,1.5"
      ];

      exec-once = [
        "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill"
        "fcitx5 -d"
        "firefox --new-window ${selected.desktop.startupPage}"
        "blueman-applet"
      ];

      env = [
        "NIXOS_OZONE_WL,1"
        "QT_QPA_PLATFORMTHEME,gtk3"
      ];

      general = {
        gaps_in = 1;
        gaps_out = 1;
        border_size = 1;
        resize_on_border = true;
        layout = "dwindle";
        "col.active_border" = "rgb(${selected.desktop.activeBorder})";
        "col.inactive_border" = "rgb(${selected.desktop.inactiveBorder})";
      };

      decoration = {
        rounding = 4;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      workspace = [
        "1,monitor:DP-1,default:true"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:DP-1"
      ];

      windowrule = [
        "match:class ^(firefox)$, workspace 1"
        "match:class ^(org.telegram.desktop)$, workspace 3"
        "match:title ^(Feishu Meetings)$, float true"
      ];

      bind = [
        "$mod, RETURN, exec, ${lib.getExe pkgs.alacritty}"
        "$mod, O, exec, ${lib.getExe' pkgs.kickoff "kickoff"}"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod SHIFT, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod, SPACE, togglefloating"

        "$mod SHIFT, A, exec, ${lib.getExe macshot}"
        "$mod SHIFT, U, exec, ${lib.getExe pkgs.pamixer} -i 5"
        "$mod SHIFT, D, exec, ${lib.getExe pkgs.pamixer} -d 5"
        "$mod SHIFT, E, exec, ${lib.getExe powermenu}"
        "$mod SHIFT, S, exec, ${grimshot} copy area"
        "$mod SHIFT, R, exec, ${lib.getExe recorder-toggle}"
        "$mod, apostrophe, exec, ${lib.getExe swaylock}"
        "$mod SHIFT, X, exit"
      ]
      ++ (
        builtins.concatLists (
          builtins.genList (
            i:
            let
              n = i + 1;
              s = toString n;
            in
            [
              "$mod, ${s}, workspace, ${s}"
              "$mod SHIFT, ${s}, movetoworkspace, ${s}"
            ]
          ) 9
        )
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
}
