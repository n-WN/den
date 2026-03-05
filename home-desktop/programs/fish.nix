{
  interactiveShellInit = ''
    if test (id --user $USER) = 1000 && test (tty) = "/dev/tty1"
      exec niri
    end
  '';

  functions = {
    rebuild = ''
      nixos-rebuild switch --sudo --flake $HOME/den
    '';
  };
}
