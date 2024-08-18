## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Cursor config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.theme.cursor;
  cursorModule = lib.types.submodule
  {
    options =
    {
      name = lib.mkOption
      {
        type        = lib.types.anything;
        description = "name of the cursor theme";
      };

      package = lib.mkOption
      {
        type        = lib.types.anything;
        description = "package that provides the cursor theme";
      };

      size = lib.mkOption
      {
        type        = lib.types.anything;
        description = "size of the cursor";
      };
    };
  };
in
{
  options.custom.gui.theme.cursor = lib.mkOption
  {
    default     = null;
    description = "cursor configuration";
    type        = lib.types.nullOr cursorModule;
  };

  config = lib.mkIf (cfg != null)
  {
    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      home.pointerCursor =
      {
        gtk.enable = true; #config.custom.gui.theme.gtk.enable;
        package    = cfg.package;
        name       = cfg.name;
        size       = cfg.size;
      };
    };
    # }}}
  };
}
