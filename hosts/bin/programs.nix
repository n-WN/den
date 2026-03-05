{ ... }:
{
  git.enable = true;
  nm-applet.enable = true;
  dconf.enable = true;

  ssh.startAgent = false;

  steam.enable = true;

  niri.enable = true;

  obs-studio = {
    enable = true;
  };

  sway.enable = false;
  fish = {
    useBabelfish = true;
    enable = true;
  };
}
