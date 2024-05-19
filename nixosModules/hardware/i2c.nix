## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## I2C config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.i2c;
in
{
  options =
  {
    custom.hardware.i2c.enable = lib.mkEnableOption "enables I2C";
  };

  config = lib.mkIf module.enable
  {
    boot.kernelModules  = [ "i2c-dev" ];
    hardware.i2c.enable = true;
  };
}
