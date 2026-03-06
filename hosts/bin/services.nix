{ pkgs }:
{
  pcscd.enable = true;
  xserver.enable = true;

  displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  desktopManager.plasma6.enable = true;

  devmon.enable = true;
  printing.enable = true;
  printing.drivers = [ pkgs.hplip ];

  tailscale.enable = true;

  xwayland-satellite = {
    enable = true;
    sessionTarget = "niri.service";
    display = ":0";
  };

  openssh.enable = true;

  udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0666", SYMLINK+="stlinkv2_%n"
  '';

  gnome.sushi.enable = true;

  blueman = {
    enable = true;
  };
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  vscode-server.enable = true;
}
