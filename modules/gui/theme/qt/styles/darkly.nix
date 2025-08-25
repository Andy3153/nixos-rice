## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Darkly config
##

{ config, lib, pkgs, ... }:

let
  cfg   = config.custom.gui.theme.qt.style.darkly;
  cfgQt = config.custom.gui.theme.qt;

  mainUser = config.custom.users.mainUser;

  # {{{ Darkly config
  darklyConf =
  {
    Style =
    {
      DolphinSidebarOpacity = 80;
      MenuBarOpacity = 80;
      MenuOpacity = 80;
      OldTabbar = true;
      ScrollBarAddLineButtons = 2;
      ScrollBarSubLineButtons = 1;
      TabDrawHighlight = true;
      ToolBarOpacity = 80;
      TransparentDolphinView = true;
      renderThinSeperatorBetweenTheScrollBar = true;
    };
  };
  # }}}
in
{
  options.custom.gui.theme.qt.style.darkly.enable = lib.mkEnableOption "enables the Darkly Qt style";

  config = lib.mkIf cfg.enable
  {
    custom.gui.theme.qt.enable     = true;     # internal
    custom.gui.theme.qt.style.name = "Darkly"; # internal

    # No option for Darkly is implemented in the NixOS modules
    #qt.style = cfgQt.style.name;
    environment.systemPackages = with pkgs; [ darkly darkly-qt5 ];

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt.style =
      {
        # No option for Darkly is implemented in the Home-Manager modules
        #name    = cfgQt.style.name;
        package = with pkgs; [ darkly darkly-qt5 ];
      };

      xdg.configFile =
      {
        "darklyrc".text = lib.generators.toINI { } darklyConf;
      };
    };
    # }}}
  };
}

