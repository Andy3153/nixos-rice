## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenRGB config
##

{ config, lib, my-pkgs, ... }:

let
  cfg            = config.custom.hardware.openrgb;
  openrgbPackage = my-pkgs.openrgb-with-all-plugins-git;
in
{
  options.custom.hardware.openrgb.enable = lib.mkEnableOption "enables OpenRGB";

  config = lib.mkIf cfg.enable
  {
    custom.hardware.i2c.enable = lib.mkForce true; # force enable custom i2c

    services.hardware.openrgb =
    {
      enable  = true;
      package = openrgbPackage;
    };
  };
}
