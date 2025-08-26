{
  pkgs,
  username,
  inputs,
  lib,
  config,
  ...
}:
{
  time.timeZone = "Asia/Shanghai";

  hardware.bluetooth.enable = true;

  nixpkgs.overlays = [
    # inputs.niri.overlays.niri
  ];

  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  # chaotic.scx.enable = true;

  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        "application/x-xdg-protocol-tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/mpv" = [ "mpv-handler.desktop" ];
        "application/pdf" = [ "sioyek.desktop" ];
      }
      // lib.genAttrs [
        "x-scheme-handler/unknown"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
        "text/html"
      ] (_: "firefox.desktop");
    };
    # portal.wlr.enable = true;
    # portal.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$cI8ZFWS0NPEKvvgL/Fg86/$OFcaAf.GpnGu6vG.WogZzdnIuwigBcPR8ZCJ.vdglyB";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHysCjoqwXAumW+cUCcFZDpC9yLx3Jh7x5du7r21fPE4"
    ];
    extraGroups = [
      "adbusers"
      "wheel"
      "docker"
      "networkmanager"
      "realtime"
      "dialout"
      "libvirtd"
    ];
  };

  system.stateVersion = "25.11";
}
