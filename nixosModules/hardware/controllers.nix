## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Controllers config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.controllers;
in
{
  options.custom.hardware.controllers.xbox.enable = lib.mkEnableOption "enables Xbox controllers";

  config = lib.mkIf cfg.xbox.enable
  {
    hardware =
    {
      xone.enable    = true;
      xpadneo.enable = true;
    };

    custom.nix.unfreeWhitelist = [ "xow_dongle-firmware" ];
  };
}
