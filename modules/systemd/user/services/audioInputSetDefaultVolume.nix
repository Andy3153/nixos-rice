## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Audio input set default volume systemd user service config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.systemd.user.services.audioInputSetDefaultVolume;
  mainUser = config.custom.users.mainUser;

  desc = "Set default audio input volume";

  audioInputDefaultVolume = builtins.toString config.services.pipewire.wireplumber.extraConfig."10-default-source-volume"."wireplumber.settings"."device.routes.default-source-volume";
in
{
  options.custom.systemd.user.services.audioInputSetDefaultVolume.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    systemd.user.services.audioInputSetDefaultVolume =
    {
      Unit =
      {
        Description = desc;
        After       = [ "wireplumber.service" ];
        Wants       = [ "wireplumber.service" ];

        StartLimitBurst     = 10;
        ConditionPathExists = "!%t/audioInputSetDefaultVolume.lock";
      };

      Install.WantedBy = [ "default.target" ];

      Service =
      {
        Type          = "oneshot";
        ExecStart     = ''${lib.getExe' pkgs.wireplumber "wpctl"} set-volume --limit 1.5 @DEFAULT_AUDIO_SOURCE@ ${audioInputDefaultVolume}'';
        ExecStartPost = ''${lib.getExe' pkgs.coreutils "touch"} %t/audioInputSetDefaultVolume.lock'';

        RemainAfterExit = true;

        Restart    = "on-failure";
        RestartSec = "0.5s";
      };
    };
  };
  # }}}
  };
}
