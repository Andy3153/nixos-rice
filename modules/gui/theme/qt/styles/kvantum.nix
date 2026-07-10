## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Kvantum config
##

{ config, lib, ... }:

# {{{ Variables
let
  cfg      = config.custom.gui.theme.qt.style.kvantum;
  mainUser = config.custom.users.mainUser;
in
# }}}
{
  # {{{ Options
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
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    custom.gui.theme.qt.enable     = true;      # internal
    custom.gui.theme.qt.style.name = "kvantum"; # internal

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      qt.kvantum =
      {
        enable                 = true;
        settings.General.theme = cfg.theme.name;
        themes                 = [ cfg.theme.package ];
      };
    };
    # }}}
  };
  # }}}
}
