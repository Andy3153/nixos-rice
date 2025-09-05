## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Steam config
##

{ config, options, lib, ... }:

let
  cfg     = config.custom.programs.steam;
in
{
  options.custom.programs.steam =
  {
    enable                  = lib.mkEnableOption "enables Steam";
    gamescopeSession.enable = lib.mkEnableOption "enables Steam GameScope session";

    extraPackages = lib.mkOption
    {
      type        = options.programs.steam.extraPackages.type;
      default     = options.programs.steam.extraPackages.default;
      description = "extra packages to add to the Steam FHSEnv (also used by steam-run)";
    };
  };

  config = lib.mkIf cfg.enable
  {
    programs.steam =
    {
      enable                       = true;
      dedicatedServer.openFirewall = true;
      extest.enable                = true; # for-steam for-controllers
      extraPackages                = cfg.extraPackages;
      gamescopeSession.enable      = cfg.gamescopeSession.enable;
      protontricks.enable          = true; # for-steam for-wine
      remotePlay.openFirewall      = true;
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
