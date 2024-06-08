## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## TUF fan speed systemd service config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.services.TUFFanSpeed;
in
{
  options.custom.systemd.services.TUFFanSpeed.enable = lib.mkEnableOption "systemd service that changes an ASUS TUF's fan speed to 'Performance' at boot";

  config = lib.mkIf cfg.enable
  {
    systemd.services.TUFFanSpeed =
    {
      enable      = lib.mkDefault true;
      description = "systemd service that changes an ASUS TUF's fan speed to 'Performance' at boot";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig =
      {
        Type    = "oneshot";
        Restart = "on-failure";
        ExecStart = "${lib.getExe pkgs.bash} -c 'echo 1 > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy'";
      };
    };
  };
}
