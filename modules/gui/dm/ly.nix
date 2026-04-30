## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Ly config
##

{ config, lib, ... }:

let
  cfg       = config.custom.gui.dm.ly;
  batteryId = config.custom.hardware.laptop.batteryId;
  dmSession = config.services.displayManager.defaultSession;
  mainUser  = config.custom.users.mainUser;
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
        auto_login_user    = mainUser;

        battery_id = lib.mkIf (batteryId != null) batteryId;

        bigclock         = "en";
        bigclock_seconds = true;

        clear_password = true;
      };
    };
  };
}
