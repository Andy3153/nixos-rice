## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## MPD config
##

{ config, lib, ... }:

let
  cfg         = config.custom.services.mpd;
  mainUser    = config.custom.users.mainUser;
  mainUserUID = config.users.users.${mainUser}.uid;
  HM          = config.home-manager.users.${mainUser};
  musicDir    = HM.xdg.userDirs.music;
  dataDir     = "${musicDir}/.mpd";
in
{
  options.custom.services.mpd =
  {
    enable = lib.mkEnableOption "enables MPD";

    discord-rpc.enable = lib.mkOption
    {
      type        = lib.types.bool;
      default     = true;
      example     = false;
      description = "enables MPD Discord RPC";
    };

    listenbrainz.enable = lib.mkOption
    {
      type        = lib.types.bool;
      default     = true;
      example     = false;
      description = "enables ListenBrainz MPD client";
    };
  };

  config = lib.mkIf cfg.enable
  {
    custom.services.pipewire.enable = true;

    services.mpd =
    {
      enable          = true;
      startWhenNeeded = true;
      user            = mainUser;

      dataDir           = dataDir;

      settings =
      {
        db_file            = "${dataDir}/tag_cache";
        music_directory    = musicDir;
        playlist_directory = "${dataDir}/playlists";

        audio_output =
        [
          {
            type = "pipewire";
            name = "PipeWire Output";
          }
        ];
      };
    };

    # MPD PipeWire fix
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    systemd.services.mpd.environment.XDG_RUNTIME_DIR =
      "/run/user/${toString mainUserUID}";

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    services =
    {
      mpd-discord-rpc.enable  = cfg.discord-rpc.enable;  # for-discord for-mpd
      listenbrainz-mpd.enable = cfg.listenbrainz.enable; # for-mpd
    };
  };
  # }}}
  };
}
