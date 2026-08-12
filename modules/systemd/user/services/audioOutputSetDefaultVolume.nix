## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Audio output set default volume systemd user service config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.systemd.user.services.audioOutputSetDefaultVolume;
  mainUser = config.custom.users.mainUser;

  desc = "Set default audio output volume";

  audioOutputDefaultVolume = builtins.toString config.services.pipewire.wireplumber.extraConfig."10-default-sink-volume"."wireplumber.settings"."device.routes.default-sink-volume";
in
{
  options.custom.systemd.user.services.audioOutputSetDefaultVolume.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    systemd.user.services.audioOutputSetDefaultVolume =
    {
      Unit =
      {
        Description = desc;
        After       = [ "wireplumber.service" ];
        Wants       = [ "wireplumber.service" ];

        StartLimitBurst     = 10;
        ConditionPathExists = "!%t/audioOutputSetDefaultVolume.lock";
      };

      Install.WantedBy = [ "default.target" ];

      Service =
      {
        Type          = "oneshot";
        ExecStart     = ''${lib.getExe' pkgs.wireplumber "wpctl"} set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ ${audioOutputDefaultVolume}'';
        ExecStartPost = ''${lib.getExe' pkgs.coreutils "touch"} %t/audioOutputSetDefaultVolume.lock'';

        RemainAfterExit = true;

        Restart    = "on-failure";
        RestartSec = "0.5s";
      };
    };
  };
  # }}}
  };
}
