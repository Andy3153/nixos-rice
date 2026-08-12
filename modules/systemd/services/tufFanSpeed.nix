## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## TUF fan speed systemd service config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.services.tufFanSpeed;

  desc = "Change an ASUS TUF's fan speed to 'Performance' at boot";
in
{
  options.custom.systemd.services.tufFanSpeed.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
    systemd.services.tufFanSpeed =
    {
      description = desc;
      wantedBy    = [ "multi-user.target" ];

      startLimitBurst = 10;

      unitConfig.ConditionPathExists = "!%t/tufFanSpeed.lock";

      serviceConfig =
      {
        Type          = "oneshot";
        ExecStart     = ''${lib.getExe pkgs.bash} -c "echo 1 > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"'';
        ExecStartPost = ''${lib.getExe' pkgs.coreutils "touch"} %t/tufFanSpeed.lock'';

        RemainAfterExit = true;

        Restart    = "on-failure";
        RestartSec = "0.5s";
      };
    };
  };
}
