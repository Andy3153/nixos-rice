## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Bluetooth config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.bluetooth;
in
{
  options =
  {
    custom.hardware.bluetooth.enable = lib.mkEnableOption "enables Bluetooth";
  };

  config = lib.mkIf module.enable
  {
    hardware.bluetooth =
    {
      enable      = true;
      powerOnBoot = false;
    };
  };
}
