{ config, lib, modulesPath, ... }:

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

  networking.useDHCP   = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
