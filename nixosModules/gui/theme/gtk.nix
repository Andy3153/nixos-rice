## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GTK theming config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.theme.gtk;
  gtkModule = lib.types.submodule
  {
    options.theme =
    {
      name = lib.mkOption
      {
        type        = lib.types.str;
        description = "name of the GTK theme";
      };

      package = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.package;
        default     = null;
        description = "package that provides the GTK theme";
      };
    };
  };
in
{
  options.custom.gui.theme.gtk = lib.mkOption
  {

    type        = lib.types.nullOr gtkModule;
    default     = lib.types.null;
    description = "GTK theme configuration";
  };

  config = lib.mkIf (cfg != null)
  {
    gtk.iconCache.enable = lib.mkDefault true;

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      gtk =
      {
        enable = lib.mkDefault true;
        gtk2.configLocation = "${config.home-manager.users.${config.custom.users.mainUser}.xdg.configHome}/gtk-2.0/gtkrc";

        theme =
        {
          name    = cfg.theme.name;
          package = cfg.theme.package;
        };
      };

      # Apply GTK theme to GTK4 apps
      xdg.configFile =
      {
        "gtk-4.0/assets".source = "${cfg.theme.package}/share/themes/${cfg.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${cfg.theme.package}/share/themes/${cfg.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${cfg.theme.package}/share/themes/${cfg.theme.name}/gtk-4.0/gtk-dark.css";
      };
    };
    # }}}
  };
}
