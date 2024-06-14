## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Steam config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.steam;
in
{
  options.custom.programs.steam.enable = lib.mkEnableOption "enables Steam";

  config = lib.mkIf cfg.enable
    {
      programs.steam =
        {
          enable = lib.mkDefault true;
          #gamescopeSession.enable      = lib.mkDefault true;
          dedicatedServer.openFirewall = lib.mkDefault true;
          remotePlay.openFirewall = lib.mkDefault true;
        };

      custom.programs.java.enable = lib.mkDefault true;
    };
}
