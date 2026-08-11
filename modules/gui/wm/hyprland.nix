## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.wm.hyprland;
in
{
  options.custom.gui.wm.hyprland.enable = lib.mkEnableOption "enables Hyprland";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      gui.dm =
      {
        autologin.enable = true;
        defaultSession   = "hyprland";
      };

      xdg.portal.enable = true;
    };

    programs.hyprland.enable = true;
  };
}
