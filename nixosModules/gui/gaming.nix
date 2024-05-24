## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Gaming config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.gaming;
in
{
  options.custom.gui.gaming.enable = lib.mkEnableOption "enables various gaming things";

  config = lib.mkIf cfg.enable
  {
    custom.programs.steam.enable    = lib.mkDefault true;
    custom.programs.gamemode.enable = lib.mkDefault true;
  };
}
