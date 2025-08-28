{
  interactiveShellInit = ''
    if test (id --user $USER) = 1000 && test (tty) = "/dev/tty1"
      exec sway
    end
  '';

  functions = {
    rebuild = ''
      nixos-rebuild switch --sudo --flake $HOME/den
    '';
  };
}
