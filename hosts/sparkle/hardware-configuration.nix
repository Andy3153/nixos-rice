{ config, lib, modulesPath, ... }:

let
  # {{{ Variables
  mainDeviceName   = "sparkle-crypt";
  mainDevice       = "/dev/mapper/${mainDeviceName}";
  mainUser         = config.custom.users.mainUser;
  homeDir          = "/home/${mainUser}";
  # }}}
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # {{{ Detected kernel modules
  boot =
  {
    initrd.availableKernelModules =
      [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
  };
  # }}}

  # {{{ Firmware and microcode
  hardware =
  {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode     = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
  # }}}

  # {{{ Filesystems
  boot.initrd.luks.devices.${mainDeviceName}.device =
    "/dev/disk/by-uuid/f95604b4-c637-404b-af25-023a0a0c0820";

  fileSystems =
  {
    "/" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/boot" =
    {
      device = "/dev/disk/by-partlabel/EFI\\x20System\\x20Partition";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/.btrfs-root" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=/" ];
    };

    "/.swap" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

    "/nix" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/var/cache" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=var-cache" ];
    };

    "/var/log" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=var-log" ];
    };

    "/var/tmp" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=var-tmp" ];
    };

    "/var/lib/libvirt/images" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=vms" ];
    };

    "/home" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    "${homeDir}/games" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=games" ];
    };

    "${homeDir}/torrents" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=torrents" ];
    };
  };

  swapDevices = [ { device = "/.swap/swapfile"; } ];
  # }}}

  networking.useDHCP   = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
