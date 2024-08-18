## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GameMode config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.gamemode;
in
{
  options.custom.programs.gamemode.enable = lib.mkEnableOption "enables Feral GameMode";
  config.programs.gamemode.enable         = cfg.enable;
}
