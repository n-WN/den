{root, lib, pkgs }:
with pkgs;
# let
#  inherit (root.pkgs) warp;
# in
[
  wl-clipboard
  swayidle
  tdesktop
  firefox-wayland
  # animeko
  vscode-fhs
  
  warp-terminal

  _1password-gui

  wechat
  qq
  feishu
]
