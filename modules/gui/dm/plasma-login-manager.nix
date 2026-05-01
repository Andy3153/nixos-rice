## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Plasma Login Manager config
##

{ config, lib, ... }:

let
  cfg           = config.custom.gui.dm.plasma-login-manager;
  dmSession     = config.custom.gui.dm.defaultSession;
  autologinUser = config.custom.gui.dm.autologin.user;
in
{
  options.custom.gui.dm.plasma-login-manager.enable = lib.mkEnableOption "enables Plasma Login Manager";

  config = lib.mkIf cfg.enable
  {
    services.displayManager.plasma-login-manager =
    {
      enable = true;

      settings =
      {
        Autologin =
        {
          User    = autologinUser;
          Session = "${dmSession}.desktop";
        };
      };
    };
  };
}
