## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Default session config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.dm.defaultSession;
in
{
  options.custom.gui.dm.defaultSession = lib.mkOption
  {
    type        = lib.types.nullOr lib.types.str;
    default     = null;
    example     = "hyprland";
    description = "default login session";
  };

  config.services.displayManager.defaultSession = lib.mkIf (cfg != null) cfg;
}
