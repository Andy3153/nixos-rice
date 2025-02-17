{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # {{{ Boot
  boot.initrd =
  {
    services.lvm.enable    = true;
  };
  # }}}

  # {{{ Filesystems
  # }}}

  networking.useDHCP   = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
