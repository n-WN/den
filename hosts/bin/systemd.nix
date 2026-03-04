{ pkgs }:
{
  services.nix-daemon.environment = {
    HTTP_PROXY = "http://10.3.50.52:7890";
    HTTPS_PROXY = "http://10.3.50.52:7890";
    ALL_PROXY = "socks5h://10.3.50.52:1080";
    NO_PROXY = "127.0.0.1,localhost,::1";
  };

  # network = {
  #   enable = true;
  #   # wait-online.anyInterface = true;

  #   networks = {
  #     "21-virtualization-interfaces".extraConfig = ''
  #       [Match]
  #       Name=docker* virbr* lxdbr* veth* vboxnet*

  #       [Link]
  #       Unmanaged=yes
  #     '';

  #     "enp14s0" = {
  #       name = "enp14s0";
  #       networkConfig.DHCP = "yes";
  #     };
  #   };
  # };
}
