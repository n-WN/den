{ pkgs }:
{
  enable = true;
  theme = {
    # package = pkgs.numix-gtk-theme;
    package = pkgs.gnome-themes-extra;
    # name = "Numix";
    name = "Adwaita-dark";
  };
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
  gtk3.extraConfig = {
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
  };
}
