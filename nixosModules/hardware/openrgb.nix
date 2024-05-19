## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenRGB config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.openrgb;
in
{
  options =
  {
    custom.hardware.openrgb.enable = lib.mkEnableOption "enables OpenRGB";
  };

  config = lib.mkIf module.enable
  {
    services.udev.packages = [ pkgs.openrgb ];
    services.hardware.openrgb.enable = true;
  };
}
