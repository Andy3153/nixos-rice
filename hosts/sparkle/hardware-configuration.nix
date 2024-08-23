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

  # {{{ Boot
  boot =
  {
    initrd.availableKernelModules =
      [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
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
      options = [ "subvol=nixos/root" ];
    };

    "/boot" =
    {
      device = "/dev/disk/by-partlabel/NixOS\\x20ESP";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/.btrfs-root" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=/" ];
    };

    "/.snapshots" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/snapshots" ];
    };

    "/.snapshots.externalhdd" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/snapshots.externalhdd" ];
    };

    "/.swap" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/swap" ];
    };

    "/nix" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/nix" ];
    };

    "/var/cache" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/var-cache" ];
    };

    "/var/log" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/var-log" ];
    };

    "/var/tmp" =
    {
      device = mainDevice;
      fsType = "btrfs";
      options = [ "subvol=nixos/var-tmp" ];
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
      options = [ "subvol=nixos/home" ];
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

    # {{{ Bind mounts
    "${homeDir}/music" =
    {
      device = "/.btrfs-root/home/andy3153/music";
      options = [ "bind" ];
    };

    "${homeDir}/.local/share/Steam" =
    {
      device = "/.btrfs-root/home/andy3153/.local/share/Steam";
      options = [ "bind" ];
    };

    "${homeDir}/.var/app/io.gitlab.librewolf-community/.librewolf" =
    {
      device = "/.btrfs-root/home/andy3153/.librewolf";
      options = [ "bind" ];
    };
    # }}}
  };

  swapDevices = [ { device = "/.swap/swapfile"; } ];
  # }}}

  networking.useDHCP                 = lib.mkDefault true;
  nixpkgs.hostPlatform               = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
