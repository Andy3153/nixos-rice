## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Kvantum config
##

{ config, lib, pkgs, ... }:

let
  cfg   = config.custom.gui.theme.qt.style.kvantum;
  cfgQt = config.custom.gui.theme.qt;

  mainUser = config.custom.users.mainUser;

  # {{{ Kvantum config
  kvantumConf = { General.theme = cfg.theme.name; };
  # }}}
in
{
  options.custom.gui.theme.qt.style.kvantum =
  {
    enable = lib.mkEnableOption "enables the Kvantum Qt style";

    theme =
    {
      name = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        description = "name of the Kvantum theme";
      };

      package = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.package;
        default     = null;
        description = "package that provides the Kvantum theme";
      };
    };
  };

  config = lib.mkIf cfg.enable
  {
    custom.gui.theme.qt.enable     = true;      # internal
    custom.gui.theme.qt.style.name = "kvantum"; # internal

    qt.style = "kvantum";

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt.style =
      {
        name    = "kvantum";
        package = pkgs.kdePackages.qtstyleplugin-kvantum;
      };

      xdg.configFile =
      {
        # Kvantum config
        "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } kvantumConf;

        # Kvantum theme
        "Kvantum".source    = lib.mkIf (cfg.theme.package != null) "${cfg.theme.package}/share/Kvantum";
        "Kvantum".recursive = true;
      };
    };
    # }}}
  };
}

