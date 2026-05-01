## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Ly config
##

{ config, lib, ... }:

let
  cfg           = config.custom.gui.dm.ly;
  batteryId     = config.custom.hardware.laptop.batteryId;
  dmSession     = config.custom.gui.dm.defaultSession;
  autologinUser = config.custom.gui.dm.autologin.user;
in
{
  options.custom.gui.dm.ly.enable = lib.mkEnableOption "enables Ly";

  config = lib.mkIf cfg.enable
  {
    services.displayManager.ly =
    {
      enable     = true;
      x11Support = false;

      settings =
      {
        animation  = "colormix";
        auth_fails = 3;

        auto_login_session = dmSession;
        auto_login_user    = autologinUser;

        battery_id = lib.mkIf (batteryId != null) batteryId;

        bigclock         = "en";
        bigclock_seconds = true;

        clear_password = true;
      };
    };
  };
}
