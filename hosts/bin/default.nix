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
  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://10.3.50.52:7890";
    HTTPS_PROXY = "http://10.3.50.52:7890";
    ALL_PROXY = "socks5h://10.3.50.52:1080";
    NO_PROXY = "127.0.0.1,localhost,::1";
  };

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
    portal.wlr.enable = true;
    portal.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    # shell = pkgs.fish;
    hashedPassword = "$6$PkX6cLlnEn8ut194$IkII8KqGocsLjgQ.z0Z7O8pxFsDUvq9.5wQv7ARIe8a7Q.Zk26RqKH9H3TqyNmzZJqYBYcAlYYc8Q.aO4muYs0";
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
