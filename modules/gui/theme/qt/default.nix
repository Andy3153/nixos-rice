## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Qt bundle
##

{ config, lib, pkgs, ... }:
let
  cfg      = config.custom.gui.theme.qt;
  mainUser = config.custom.users.mainUser;

  iconTheme = config.custom.gui.theme.icon.name;
in
{
  imports =
  [
    ./platformThemes
    ./styles
  ];

  options.custom.gui.theme.qt =
  {
    enable = lib.mkOption
    {
      type        = lib.types.bool;
      internal    = true;
      visible     = false;
      default     = false;
      description = "enables Qt theming. internal. value is only written to by modules defined in `modules/gui/theme/qt/platformThemes`, `modules/gui/theme/qt/styles` and only read by `modules/gui/theme/qt/default.nix`";
    };

    style.name = lib.mkOption
    {
      type        = lib.types.str;
      internal    = true;
      visible     = false;
      description = "name of the Qt style. internal. value is only written to by modules defined in `modules/gui/theme/qt/styles` and only read by modules defined in `modules/gui/theme/qt/platformThemes`.";
    };
  };

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = with pkgs.kdePackages;
    [
      qtsvg
      wayqt
      qtwayland
    ];

    qt.enable = true;

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt =
      {
        enable = true;

        kde.settings =
        {
          kdeglobals =
          {
            Icons.Theme = iconTheme;
            KDE.widgetStyle = cfg.style.name;
          };
        };
      };
    };
    # }}}
  };
}
