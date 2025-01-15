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

      gamescopeSession = lib.mkIf cfg.gamescopeSession.enable
      {
        enable = true;
        env = lib.mkIf nvPrime.enable
        {
          __NV_PRIME_RENDER_OFFLOAD          = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME          = "nvidia";
          __VK_LAYER_NV_optimus              = "NVIDIA_only";
        };
      };
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
