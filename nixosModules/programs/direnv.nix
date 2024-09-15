## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Direnv config
##

{ config, lib, ... }:

let
  cfg      = config.custom.programs.direnv;
  cfgZsh   = config.custom.programs.zsh;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.direnv.enable = lib.mkEnableOption "enables Direnv";

  config = lib.mkIf cfg.enable
  {
    # {{{ Direnv program
    programs.direnv =
    {
      enable               = true;
      enableZshIntegration = cfgZsh.enable;
      nix-direnv.enable    = true;
    };
    # }}}

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      # {{{ Direnv program
      programs.direnv =
      {
        enable               = true;
        enableZshIntegration = cfgZsh.enable;
        nix-direnv.enable    = true;
      };
      # }}}
    };
    # }}}
  };
}
