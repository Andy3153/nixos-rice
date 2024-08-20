## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## EFI boot config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.uefiBoot;
in
{
  options.custom.boot.uefiBoot.enable = lib.mkEnableOption "enables UEFI boot";

  config = lib.mkIf cfg.enable
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
  };
}
