## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Piper & ratbagd config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.piper;
in
{
  options.custom.hardware.piper.enable = lib.mkEnableOption "enables Piper & ratbagd";

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages    = [ pkgs.piper ];
    services.ratbagd.enable = true;
  };
}
