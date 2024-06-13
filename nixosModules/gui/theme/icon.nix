## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Icon theme config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.theme.icon;
  iconModule = lib.types.submodule
  {
    options =
    {
      name = lib.mkOption
      {
        type        = lib.types.str;
        description = "name of the icon theme";
      };

      package = lib.mkOption
      {
        type        = lib.types.package;
        description = "package that provides the icon theme";
      };
    };
  };
in
{
  options.custom.gui.theme.icon = lib.mkOption
  {
    default     = lib.types.null;
    description = "icon theme configuration";
    type        = lib.types.nullOr iconModule;
  };

  config = lib.mkIf (cfg != null)
  {
    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      gtk.iconTheme =
      {
        name    = cfg.name;
        package = cfg.package;
      };
    };
    # }}}
  };
}
