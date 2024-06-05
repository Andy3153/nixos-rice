## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## I2C config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.i2c;
in
{
  options.custom.hardware.i2c.enable = lib.mkEnableOption "enables I2C";

  config = lib.mkIf cfg.enable
  {
    boot.kernelModules         = [ "i2c-dev" ];
    environment.systemPackages = [ pkgs.i2c-tools ];
    hardware.i2c.enable        = lib.mkDefault true;
  };
}
