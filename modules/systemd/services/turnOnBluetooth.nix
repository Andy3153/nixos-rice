## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Turn on Bluetooth systemd service config
##

{ config, options, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.services.turnOnBluetooth;
  opt = options.custom.systemd.services.turnOnBluetooth;
in
{
  options.custom.systemd.services.turnOnBluetooth.enable = lib.mkEnableOption "systemd service that turns on Bluetooth at boot";

  config = lib.mkIf cfg.enable
  {
    systemd.services.turnOnBluetooth =
    {
      enable      = true;
      description = opt.enable.description;
      wantedBy    = [ "multi-user.target" ];

      serviceConfig =
      {
        Type    = "oneshot";
        Restart = "on-failure";
        ExecStart = ''${lib.getExe' pkgs.util-linux "rfkill"} unblock bluetooth'';
      };
    };
  };
}
