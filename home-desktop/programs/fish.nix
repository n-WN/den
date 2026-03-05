{
  interactiveShellInit = ''
    if test (id --user $USER) = 1000; and test (tty) = "/dev/tty1"; and not set -q WAYLAND_DISPLAY; and not set -q DISPLAY
      echo "Select session: [h]yprland / [s]way / [n]iri (default: h)"
      read --local --prompt-str "wm> " session
      set --query session[1]; or set session h

      switch "$session"
        case h hypr hyprland ""
          exec Hyprland
        case s sway
          exec sway
        case n niri
          exec niri
        case '*'
          echo "Unknown session '$session', fallback to Hyprland"
          exec Hyprland
      end
    end
  '';

  functions = {
    rebuild = ''
      nixos-rebuild switch --sudo --flake $HOME/den
    '';
  };
}
