## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Bluetooth config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.bluetooth;
in
{
  options.custom.hardware.bluetooth.enable = lib.mkEnableOption "enables Bluetooth";

  config = lib.mkIf cfg.enable
  {
    hardware.bluetooth =
    {
      enable      = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
  };
}
