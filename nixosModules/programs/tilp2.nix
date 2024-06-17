## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## TiLP config
##

{ config, lib, pkgs, pkgs-tilp, ... }:

let
  cfg = config.custom.programs.tilp2;
in
{
  options.custom.programs.tilp2.enable = lib.mkEnableOption "enables TiLP";

  config = lib.mkIf cfg.enable
  {
    environment.systemPackages = with pkgs-tilp; [ tilp2 ];
    services.udev.packages     = with pkgs;      [ libticables2 ];
  };
}
