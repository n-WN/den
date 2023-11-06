{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fe0ecfb9-db21-43f0-915a-70c37765f181";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3307-5F4E";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.rocm-opencl-icd
      pkgs.libva
    ];
  };
  hardware.keyboard.qmk.enable = true;
}
