## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## MPV config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.programs.mpv;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.mpv.enable = lib.mkEnableOption "enables MPV";

  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      programs.mpv =
      {
        enable = true;

        # {{{ MPV package
        package =
        (pkgs.mpv.override
        {
          # {{{ MPV scripts
          scripts = with pkgs.mpvScripts;
          [
            modernx-zydezu  # custom-ui
            thumbfast       # thumbnails
            #mpv-notify-send # notifications
            mpris           # mpris
          ];
          # }}}

          mpv-unwrapped = pkgs.mpv-unwrapped.override { ffmpeg = pkgs.ffmpeg-full; };
        });
        # }}}
      };
    };
    # }}}
  };
}
