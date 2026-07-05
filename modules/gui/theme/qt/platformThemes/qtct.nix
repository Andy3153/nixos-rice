## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## QtCT config
##

{ config, lib, ... }:

# {{{ Variables
let
  cfg     = config.custom.gui.theme.qt.platformTheme.qtct;
  cfgQt   = config.custom.gui.theme.qt;
  cfgFont = config.custom.gui.theme.font;

  mainUser   = config.custom.users.mainUser;
  HM         = config.home-manager.users.${mainUser};
  configHome = HM.xdg.configHome;

  qtStyleName = cfgQt.style.name;

  iconTheme       = config.custom.gui.theme.icon.name;
  generalFont     = builtins.head     cfgFont.defaultFonts.sansSerif.names;
  generalFontSize = builtins.toString cfgFont.generalFontSize;
  fixedFont       = builtins.head     cfgFont.defaultFonts.monospace.names;
  fixedFontSize   = builtins.toString cfgFont.fixedFontSize;

  # {{{ QtCT config
  qtctConf =
  {
    # {{{ Appearance
    Appearance =
    {
      color_scheme_path = if (cfg.theme.name != null) then "${configHome}/qt6ct/colors/${cfg.theme.name}.conf" else "";
      custom_palette    = if (cfg.theme.name != null) then true else "";
      icon_theme        = iconTheme;
      standard_dialogs  = "xdgdesktopportal";
      style             = qtStyleName;
    };
    # }}}

    # {{{ Fonts
    Fonts =
    {
      fixed   = "\"${fixedFont},${fixedFontSize}\"";
      general = "\"${generalFont},${generalFontSize}\"";
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
in
# }}}
{
  # {{{ Options
  options.custom.gui.theme.qt.platformTheme.qtct=
  {
    enable = lib.mkEnableOption "enables the QtCT Qt platform theme";

    theme =
    {
      name = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        description = "name of the QtCT theme";
      };

      package = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.package;
        default     = null;
        description = "package that provides the QtCT theme";
      };
    };
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    custom.gui.theme.qt.enable = true; # internal

    qt.platformTheme = "qt5ct";

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt =
      {
        platformTheme.name = "qtct";

        qt5ctSettings = qtctConf;
        qt6ctSettings = qtctConf;
      };

      # {{{ QtCT theme
      xdg.configFile."qt5ct/colors" = lib.mkIf (cfg.theme.package != null)
      {
        source    = "${cfg.theme.package}/share/qt5ct/colors";
        recursive = true;
      };

      xdg.configFile."qt6ct/colors" = lib.mkIf (cfg.theme.package != null)
      {
        source    = "${cfg.theme.package}/share/qt6ct/colors";
        recursive = true;
      };
      # }}}
    };
    # }}}
  };
  # }}}
}
