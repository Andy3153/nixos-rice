## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Neovim config
##

{ config, lib, ... }:

let
  cfg           = config.custom.programs.zsh;
  xdgConfigHome = config.home-manager.users.${config.custom.users.mainUser}.xdg.configHome;
in
{
  options.custom.programs.zsh =
  {
    enable              = lib.mkEnableOption "enables Zsh";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Zsh program
    programs.zsh =
    {
      enable   = true;
      histFile = "$HOME/.local/share/zsh/zsh-history";
      histSize = 1000000;
    };
    # }}}

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    # {{{ Config files
    home.file = lib.mkIf cfg.enableCustomConfigs
    {
      ".config/zsh".source = /home/andy3153/src/sh/andy3153-zshrc;
    };
    # }}}

    # {{{ Zsh program
    programs.zsh =
    {
      enable = true;
      dotDir = ".config/zsh";
    };
    # }}}
  };
  # }}}
  };
}
