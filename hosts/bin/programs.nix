{ pkgs, inputs, ... }:
{
  git.enable = true;
  nm-applet.enable = true;
  dconf.enable = true;

  ssh.startAgent = false;

  steam.enable = true;

  niri = {
    enable = true;
    package = (inputs.niri.packages.${pkgs.system}.niri-stable).overrideAttrs (old: {
      doCheck = false;
      doInstallCheck = false;
    });
  };

  hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  obs-studio = {
    enable = true;
  };

  sway.enable = true;
  fish = {
    useBabelfish = true;
    enable = true;
  };
}
