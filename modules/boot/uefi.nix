## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## UEFI boot config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.uefi;
in
{
  options.custom.boot.uefi =
  {
    enable             = lib.mkEnableOption "enables UEFI boot";
    secure-boot.enable = lib.mkEnableOption "enables UEFI Secure Boot support";
  };

  config = lib.mkMerge
  [
    (lib.mkIf cfg.enable
    {
      boot.loader.efi =
      {
        canTouchEfiVariables = true;
        efiSysMountPoint     = "/boot";
      };

      custom =
      {
        boot.loader.systemd-boot.enable = true;
        extraPackages = with pkgs;
        [
          efibootmgr # EFI
          sbctl      # EFI key-manager
        ];
      };
    })

    (lib.mkIf cfg.secure-boot.enable
    {
      boot.lanzaboote =
      {
        enable                  = true;
        autoGenerateKeys.enable = true;
        autoEnrollKeys.enable   = true;

        pkiBundle = if (lib.versionAtLeast lib.version "25.05pre")
        then "/var/lib/sbctl"
        else "/etc/secureboot";
      };

      custom.boot =
      {
        loader.systemd-boot.enable = lib.mkForce false; # Lanzaboote replaces the systemd-boot module
        uefi.enable                = lib.mkForce true;
      };
    })
  ];
}
