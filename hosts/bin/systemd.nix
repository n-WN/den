{ pkgs, lib }:
{
  services.nix-daemon.environment = {
    HTTP_PROXY = "http://10.3.50.50:7890";
    HTTPS_PROXY = "http://10.3.50.50:7890";
    ALL_PROXY = "socks5h://10.3.50.50:1080";
    NO_PROXY = "127.0.0.1,localhost,::1";
  };

  # libvirt upstream unit uses /usr/bin/sh, which does not exist on NixOS.
  # Override to a Nix store shell and explicit binaries.
  services.virt-secret-init-encryption.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.runtimeShell} -c 'umask 0077 && (${pkgs.coreutils}/bin/dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
  ];

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
