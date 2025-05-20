## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Neovim config
##

{ config, lib, pkgs, ... }:

let
  cfg                 = config.custom.programs.zsh;
  cfgGui              = config.custom.gui;

  mainUser            = config.custom.users.mainUser;
  HM                  = config.home-manager.users.${mainUser};
  mkOutOfStoreSymlink = HM.lib.file.mkOutOfStoreSymlink;

  homeDir             = HM.home.homeDirectory;
  configHome          = HM.xdg.configHome;
in
{
  options.custom.programs.zsh =
  {
    enable              = lib.mkEnableOption "enables Zsh";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";
  };

  config = lib.mkIf cfg.enable
  {
    environment.variables = { ZDOTDIR = "${configHome}/zsh"; };

    # {{{ Packages
    custom.extraPackages = lib.lists.flatten
    [
      (if cfg.enableCustomConfigs then with pkgs;
      [
        git
        lsd
        clolcat
        colordiff
        nvimpager
      ] else [])

      (if cfgGui.enable then with pkgs;
      [
        wl-clipboard
      ] else [])
    ];
    # }}}

    # {{{ Zsh program
    programs.zsh =
    {
      enable   = true;
      histFile = "$HOME/.local/share/zsh/zsh-history";
      histSize = 1000000;
    };
    # }}}

  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    # {{{ Config files
    xdg.configFile = lib.mkIf cfg.enableCustomConfigs
    {
      "zsh".source = mkOutOfStoreSymlink "${homeDir}/src/sh/andy3153-zshrc";
    };
    # }}}
  };
  # }}}
  };
}
