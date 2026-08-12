## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Audio output unmute systemd user service config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.systemd.user.services.audioOutputUnmute;
  mainUser = config.custom.users.mainUser;

  desc = "Unmute audio output";
in
{
  options.custom.systemd.user.services.audioOutputUnmute.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    systemd.user.services.audioOutputUnmute =
    {
      Unit =
      {
        Description = desc;
        After       = [ "wireplumber.service" ];
        Wants       = [ "wireplumber.service" ];

        StartLimitBurst     = 10;
        ConditionPathExists = "!%t/audioOutputUnmute.lock";
      };

      Service =
      {
        Type          = "oneshot";
        ExecStart     = ''${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ 0'';
        ExecStartPost = ''${lib.getExe' pkgs.coreutils "touch"} %t/audioOutputUnmute.lock'';

        RemainAfterExit = true;

        Restart    = "on-failure";
        RestartSec = "0.5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
  # }}}
  };
}
