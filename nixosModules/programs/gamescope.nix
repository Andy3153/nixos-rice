## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Gamescope config
##

{ config, lib, ... }:

let
  cfg   = config.custom.programs.gamescope;
  steam = config.custom.programs.steam;
in
{
  options.custom.programs.gamescope.enable = lib.mkEnableOption "enables Gamescope";

  config = lib.mkIf cfg.enable
  {
    programs.gamescope =
    {
      enable     = true;
      capSysNice = true;
    };

    custom.programs.steam.gamescopeSession.enable = lib.mkIf steam.enable true;
  };
}
