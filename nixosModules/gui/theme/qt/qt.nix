## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Qt theming config
##


{ config, lib, ... }:
let
  cfg              = config.custom.gui.theme.qt;
  cfgFont          = config.custom.gui.theme.font;

  qtStyle          = lib.mkIf cfg.style.kvantum.enable "kvantum";
  kvantumThemePkg  = cfg.style.kvantum.theme.package;
  kvantumThemeName = cfg.style.kvantum.theme.name;

  qtStyleString    = cfg.style.name;
  iconTheme        = config.custom.gui.theme.icon.name;
  generalFont      = builtins.head     cfgFont.defaultFonts.sansSerif.names;
  generalFontSize  = builtins.toString cfgFont.generalFontSize;
  fixedFont        = builtins.head     cfgFont.defaultFonts.monospace.names;
  fixedFontSize    = builtins.toString cfgFont.fixedFontSize;

  kvconfigFile     = cfg.style.kvantum.theme.kvconfigFile;
  svgFile          = cfg.style.kvantum.theme.svgFile;

  # {{{ Qt5CT config
  qt5ctConf =
  ''
    [Appearance]
    icon_theme=${iconTheme}
    standard_dialogs=xdgdesktopportal
    style=${qtStyleString}

    [Fonts]
    fixed="${fixedFont},${fixedFontSize},-1,5,50,0,0,0,0,0"
    general="${generalFont},${generalFontSize},-1,5,50,0,0,0,0,0"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=2
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
    keyboard_scheme=3
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x3\xa6\0\0\x3\xfb\0\0\0\0\0\0\0\0\0\0\x3\xbf\0\0\x2\x44\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\x3\xa6\0\0\x3\xfb)

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
  # }}}
  # {{{ Qt6CT config
  qt6ctConf =
  ''
    [Appearance]
    icon_theme=${iconTheme}
    standard_dialogs=xdgdesktopportal
    style=${qtStyleString}

    [Fonts]
    fixed="${fixedFont},${fixedFontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
    general="${generalFont},${generalFontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=2
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
    keyboard_scheme=3
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\a_\0\0\x3\xfb\0\0\0\0\0\0\0\0\0\0\x3\xbf\0\0\x4\x1b\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\a_\0\0\x3\xfb)

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
  # }}}
  # {{{ Kvantum config
  kvantumConf =
  ''
    [General]
    theme=${kvantumThemeName}
  '';
  # }}}

  # {{{ Qt module
  qtModule = lib.types.submodule
  {
    options =
    {
      platformTheme = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = "qtct";
        description = "name of the Qt platform theme";
      };

      style =
      {
        name = lib.mkOption
        {
          type        = lib.types.nullOr lib.types.str;
          default     = "kvantum"; #this might screw me later
          description = "name of the Qt style";
        };

        kvantum =
        {
          enable = lib.mkEnableOption "enable Kvantum Qt style";
          theme =
          {
            name = lib.mkOption
            {
              type        = lib.types.str;
              description = "name of the Kvantum theme";
            };

            package = lib.mkOption
            {
              type        = lib.types.nullOr lib.types.package;
              default     = lib.types.null;
              description = "package that provides the Kvantum theme";
            };

            kvconfigFile = lib.mkOption
            {
              type        = lib.types.nullOr lib.types.str;
              default     = lib.types.null;
              description = "file that provides the Kvantum theme";
            };

            svgFile = lib.mkOption
            {
              type        = lib.types.nullOr lib.types.str;
              default     = lib.types.null;
              description = "file that provides the Kvantum element styles";
            };
          };
        };
      };
    };
  };
  # }}}
in
{
  options.custom.gui.theme.qt = lib.mkOption
  {
    type        = lib.types.nullOr qtModule;
    default     = lib.types.null;
    description = "Qt theme configuration";
  };

  config = lib.mkIf (cfg != null)
  {
    qt =
    {
      enable        = lib.mkDefault true;
      platformTheme = lib.mkIf (cfg.platformTheme == "qtct") "qt5ct";
      style         = qtStyle;
    };

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      qt =
      {
        enable             = lib.mkDefault true;
        platformTheme.name = cfg.platformTheme;
        style.name         = qtStyle;
      };

      home.packages = [ kvantumThemePkg ];

      xdg.configFile =
      {
        # Configure QtCT
        "qt5ct/qt5ct.conf".text = qt5ctConf;
        "qt6ct/qt6ct.conf".text = qt6ctConf;

        # Configure Kvantum
        "Kvantum/kvantum.kvconfig".text = kvantumConf;

        # Set Kvantum theme files
        #"Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig".source = "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig";
        #"Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg".source      = "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg";

        "Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig".source = kvconfigFile;
        "Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg".source      = svgFile;

        #"Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig".source = lib.mkMerge
        #[
        #  (lib.mkIf (cfg.style.kvantum.package != null))
        #];
        #"Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg".source      = "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg";
      };
    };
    # }}}

    #custom.gui.theme.qt.style.kvantum.kvconfigFile = lib.mkIf (cfg.style.kvantum.package != null) "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig";
  };
}
