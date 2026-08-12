## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Startup sound systemd user service config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.systemd.user.services.startupSound;
  mainUser = config.custom.users.mainUser;

  desc = "Play startup sound";
in
{
  options.custom.systemd.user.services.startupSound.enable = lib.mkEnableOption "systemd service to ${desc}";

  config = lib.mkIf cfg.enable
  {
  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    systemd.user.services.startupSound =
    {
      Unit =
      {
        Description = desc;

        After =
        [
          "wireplumber.service"
          "graphical-session.target"
        ];

        PartOf = [ "graphical-session.target" ];
        Wants  = [ "wireplumber.service" ];

        StartLimitBurst = 10;

        X-RestartIfChanged = false;
      };

      Install.WantedBy = [ "graphical-session.target" ];

      Service =
      {
        Type      = "oneshot";
        ExecStart = ''${lib.getExe pkgs.libcanberra-gtk3} --id sounds/desktop-login'';

        Restart    = "on-failure";
        RestartSec = "0.5s";
      };
    };
  };
  # }}}
  };
}
