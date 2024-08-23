{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # {{{ Boot
  boot.initrd =
  {
    availableKernelModules = [ "xhci_pci" "uas" ];
    kernelModules          = [ "dm-snapshot" ];
    services.lvm.enable    = true;
  };
  # }}}

  # {{{ Filesystems
  fileSystems =
  {
    "/" = lib.mkForce
    {
      device = "/dev/ember/root";
      fsType = "ext4";
    };

    "/boot" =
    {
      device = "/dev/disk/by-label/RPI_BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" =
    {
      device = "/dev/ember/home";
      fsType = "ext4";
    };

    "/var/lib/docker" =
    {
      device = "/dev/ember/docker";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/dev/ember/swap"; } ];
  # }}}

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
