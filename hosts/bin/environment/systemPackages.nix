{ pkgs, inputs, ... }:
with pkgs;
[
  nautilus

  wget
  bat
  fzf
  lazygit
  ranger
  unzip
  p7zip
  htop
  btop
  bottom

  sing-box
  mihomo

  sunshine

  atuin
  
  screen
  ripgrep
  pinentry-curses
  unzip
  pamixer
  acpi
  rsync
  aria2
  openssl
  android-tools
  mpv
  xwinwrap
  polkit_gnome
  thunderbird
  mpv-handler

  nix-heuristic-gc

  claude-code

  fplll
  flatter
  # Upstream 10.8 exists, but nixpkgs currently ships 10.7 and
  # requireSageTests=true can fail on this machine; keep sage usable for now.
  (sage.override { requireSageTests = false; })
]
