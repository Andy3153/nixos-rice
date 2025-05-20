## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Steam config
##

{ config, lib, ... }:

let
  cfg     = config.custom.programs.steam;
  nvPrime = config.custom.hardware.nvidia.prime;
in
{
  options.custom.programs.steam =
  {
    enable                  = lib.mkEnableOption "enables Steam";
    gamescopeSession.enable = lib.mkEnableOption "enables Steam GameScope session";
  };

  config = lib.mkIf cfg.enable
  {
    programs.steam =
    {
      enable                       = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall      = true;

      gamescopeSession.enable = cfg.gamescopeSession.enable;
    };

    custom =
    {
      programs.java.enable = true;

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "steam"
        "steam-original"
        "steam-run"
        "steam-unwrapped"
      ];
      # }}}
    };
  };
}
