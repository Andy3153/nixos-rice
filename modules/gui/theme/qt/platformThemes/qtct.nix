## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## QtCT config
##

{ config, lib, ... }:

let
  cfg     = config.custom.gui.theme.qt.platformTheme.qtct;
  cfgQt   = config.custom.gui.theme.qt;
  cfgFont = config.custom.gui.theme.font;

  mainUser = config.custom.users.mainUser;

  qtStyleName = cfgQt.style.name;

  iconTheme       = config.custom.gui.theme.icon.name;
  generalFont     = builtins.head     cfgFont.defaultFonts.sansSerif.names;
  generalFontSize = builtins.toString cfgFont.generalFontSize;
  fixedFont       = builtins.head     cfgFont.defaultFonts.monospace.names;
  fixedFontSize   = builtins.toString cfgFont.fixedFontSize;

  # {{{ QtCT config
  # {{{ Qt6CT
  qt6ctConf =
  {
    # {{{ Appearance
    Appearance =
    {
      icon_theme = iconTheme;
      style      = qtStyleName;
    };
    # }}}

    # {{{ Fonts
    Fonts =
    {
      fixed   = "\"${fixedFont},${fixedFontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"";
      general = "\"${generalFont},${generalFontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"";
    };
    # }}}

    # {{{ Interface
    Interface =
    {
      buttonbox_layout          = 2; # 0=Windows 1=Mac OS X 2=KDE 3=GNOME
      dialog_buttons_have_icons = 2;
      gui_effects               = "General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox";
      keyboard_scheme           = 3; # 0=Windows 1=Mac OS X 2=X11 3=KDE 4=GNOME 5=CDE
    };
    # }}}
  };
  # }}}

  # {{{ Qt5CT
  ##
  ## Same format as Qt6CT's except for minor changes, so we change those
  ##

  qt5ctFontReplace = lib.strings.replaceStrings
    [ "-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular" ]
    [ "-1,5,50,0,0,0,0,0" ];

  qt5ctConf = lib.attrsets.updateManyAttrsByPath
  [
    { path = [ "Fonts" "fixed" ];   update = qt5ctFontReplace; }
    { path = [ "Fonts" "general" ]; update = qt5ctFontReplace; }
  ] qt6ctConf;
  # }}}
  # }}}
in
{
  options.custom.gui.theme.qt.platformTheme.qtct.enable = lib.mkEnableOption "enables the QtCT Qt platform theme";

  config = lib.mkIf cfg.enable
  {
    custom.gui.theme.qt.enable = true; # internal

    qt.platformTheme = "qt5ct";

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt.platformTheme.name = "qtct";

      xdg.configFile =
      {
        "qt5ct/qt5ct.conf".text = lib.generators.toINI { } qt5ctConf;
        "qt6ct/qt6ct.conf".text = lib.generators.toINI { } qt6ctConf;
      };
    };
    # }}}
  };
}
