## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Audio input mute systemd user service config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.systemd.user.services.audioInputMute;
  mainUser = config.custom.users.mainUser;

  desc = "Mute audio input";
in
{
  options.custom.systemd.user.services.audioInputMute.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    systemd.user.services.audioInputMute =
    {
      Unit =
      {
        Description = desc;
        After       = [ "wireplumber.service" ];
        Wants       = [ "wireplumber.service" ];

        StartLimitBurst     = 10;
        ConditionPathExists = "!%t/audioInputMute.lock";
      };

      Service =
      {
        Type          = "oneshot";
        ExecStart     = ''${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ 1'';
        ExecStartPost = ''${lib.getExe' pkgs.coreutils "touch"} %t/audioInputMute.lock'';

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
