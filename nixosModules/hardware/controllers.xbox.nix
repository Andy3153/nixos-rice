## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Xbox controllers config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.controllers.xbox;
in
{
  options.custom.hardware.controllers.xbox.enable = lib.mkEnableOption "enables Xbox controllers";

  config = lib.mkIf cfg.enable
  {
    hardware =
    {
      xone.enable    = lib.mkDefault true;
      xpadneo.enable = lib.mkDefault true;
    };
  };
}
