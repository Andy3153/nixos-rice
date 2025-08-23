## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Qt theming config
##

{ config, lib, pkgs, ... }:
let
  cfg              = config.custom.gui.theme.qt;
  cfgFont          = config.custom.gui.theme.font;

  qtStyle          = lib.mkIf cfg.style.kvantum.enable "kvantum";
  kvantumThemeName = cfg.style.kvantum.theme.name;
  kvconfigFile     = cfg.style.kvantum.theme.kvconfigFile;
  svgFile          = cfg.style.kvantum.theme.svgFile;

  qtStyleString    = config.custom.gui.theme.qt.style.name;
  iconTheme        = config.custom.gui.theme.icon.name;
  generalFont      = builtins.head     cfgFont.defaultFonts.sansSerif.names;
  generalFontSize  = builtins.toString cfgFont.generalFontSize;
  fixedFont        = builtins.head     cfgFont.defaultFonts.monospace.names;
  fixedFontSize    = builtins.toString cfgFont.fixedFontSize;

  # {{{ QtCT config
  # {{{ Qt6CT
  qt6ctConf =
  {
    # {{{ Appearance
    Appearance =
    {
      icon_theme = iconTheme;
      style      = qtStyleString;

      #standard_dialogs = "xdgdesktopportal";
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
  ## Same format as Qt6CT's except for the font, so we replace the format there
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

  # {{{ Kvantum config
  kvantumConf = { General.theme = kvantumThemeName; };
  # }}}

  # {{{ Kvantum module
  kvantumModule = lib.types.submodule
  {
    options =
    {
      enable = lib.mkEnableOption "enable Kvantum Qt style";
      theme =
      {
        name = lib.mkOption
        {
          type        = lib.types.str;
          description = "name of the Kvantum theme";
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

        kvantum = lib.mkOption
        {
          type        = lib.types.nullOr kvantumModule;
          default     = null;
          # {{{ Example Kvantum module
          example     = lib.literalExpression
          ''
            {
              enable = true;
              theme =
              let
                themePkg     = pkgs.catppuccin-kvantum.override
                {
                  variant = "Mocha";
                  accent  = "Blue";
                };
                themeName    = config.custom.gui.theme.qt.style.kvantum.theme.name;

                kvconfigFile = "\$\{themePkg\}/share/Kvantum/\$\{themeName\}/\$\{themeName\}.kvconfig";
                svgFile      = "\$\{themePkg\}/share/Kvantum/\$\{themeName\}/\$\{themeName\}.svg";
              in
              {
                name         = "Catppuccin-Mocha-Blue";
                kvconfigFile = kvconfigFile;
                svgFile      = svgFile;
              };
            };

            --------
            OR
            --------

            {
              enable = true;
              theme =
              let
                catppuccinRepo = pkgs.fetchFromGitHub
                \{
                  owner = "catppuccin";
                  repo  = "Kvantum";
                  hash  = "sha256-aFS50Q6ezhiFU9ht14KUr/ZWskYMo8zi0IG4l/o7Bxk=";
                  rev   = "a8d05868f8f0475d584949d4b82ebd33e9e68429";
                \};

                catppuccinVariant = "mocha";
                catppuccinAccent  = "blue";

                filePath = "\$\{catppuccinRepo\}/themes/\$\{catppuccinVariant\}/\$\{catppuccinVariant\}-\$\{catppuccinAccent\}/\$\{catppuccinVariant\}-\$\{catppuccinAccent\}";

                kvconfigFile = "\$\{filePath\}.kvconfig";
                svgFile      = "\$\{filePath\}.svg";
              in
              {
                name         = "Catppuccin-Mocha-Blue";
                kvconfigFile = kvconfigFile;
                svgFile      = svgFile;
              };
            };

            --------
            OR
            --------

            {
              enable = true;
              theme =
              let
                catppuccinRepo = pkgs.fetchFromGitHub
                {
                  owner = "catppuccin";
                  repo  = "Kvantum";
                  hash  = "sha256-aFS50Q6ezhiFU9ht14KUr/ZWskYMo8zi0IG4l/o7Bxk=";
                  rev   = "a8d05868f8f0475d584949d4b82ebd33e9e68429";
                };

                themeName    = config.custom.gui.theme.qt.style.kvantum.theme.name;
                catppuccinVariant = "mocha";
                catppuccinAccent  = "blue";

                filePath = "\$\{catppuccinRepo\}/themes/\$\{catppuccinVariant\}/\$\{catppuccinVariant\}-\$\{catppuccinAccent\}/\$\{catppuccinVariant\}-\$\{catppuccinAccent\}";

                svgFile      = "\$\{filePath\}.svg";

                kvconfigContents = pkgs.writeTextFile
                \{
                  name = "\$\{themeName\}.kvconfig";
                  text =
                  ''
                  '';
                \};

                kvconfigFile     = "\$\{kvconfigContents\}";
              in
              {
                name         = "Catppuccin-Mocha-Blue";
                kvconfigFile = kvconfigFile;
                svgFile      = svgFile;
              };
            };
          '';
          # }}}
          description = "kvantum settings";
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
    default     = null;
    description = "Qt theme configuration";
  };

  config = lib.mkIf (cfg != null)
  {
    custom.extraPackages = with pkgs.kdePackages;
    [
      qtsvg
      wayqt
      qtwayland
    ];

    qt =
    {
      enable        = true;
      platformTheme = lib.mkIf (cfg.platformTheme == "qtct") "qt5ct";
      #style         = qtStyle;
    };

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      qt =
      {
        enable             = true;
        platformTheme.name = cfg.platformTheme;
        style.name         = qtStyle;

        kde.settings =
        {
          kdeglobals =
          {
            Icons.Theme = iconTheme;
            KDE.widgetStyle = qtStyle;
          };
        };
      };

      xdg.configFile =
      {
        # Configure QtCT
        "qt5ct/qt5ct.conf".text = lib.generators.toINI { } qt5ctConf;
        "qt6ct/qt6ct.conf".text = lib.generators.toINI { } qt6ctConf;

        # Configure Kvantum
        "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } kvantumConf;

        # Kvantum theme files
        "Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig".source = lib.mkIf (kvconfigFile != null) kvconfigFile;
        "Kvantum/${kvantumThemeName}/${kvantumThemeName}.svg".source      = lib.mkIf (svgFile != null) svgFile;
      };
    };
    # }}}
  };
}
