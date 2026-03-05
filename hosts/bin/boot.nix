{ pkgs }:
{
  # kernelPackages = pkgs.linuxPackages_cachyos;
  loader = {
    timeout = 30;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      # Fallback Windows entry in case os-prober is unavailable or skipped.
      extraEntries = ''
        menuentry "Windows Boot Manager (EFI)" {
          search --no-floppy --fs-uuid --set=root F5EF-3E16
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      minegrub-world-sel-theme.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
