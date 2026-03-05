{ ... }:
{
  git.enable = true;
  nm-applet.enable = true;
  dconf.enable = true;

  ssh.startAgent = true;

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
