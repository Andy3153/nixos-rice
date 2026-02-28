## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Spicetify config
##

{ config, inputs, lib, pkgs, ... }:

let
  cfg       = config.custom.programs.spicetify;
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
in
{
  options.custom.programs.spicetify.enable = lib.mkEnableOption "enables Spicetify";
  config = lib.mkIf cfg.enable
  {
    programs.spicetify =
    {
      enable = true;

      # {{{ Apps
      enabledCustomApps = with spicePkgs.apps;
      [
        lyricsPlus
        newReleases
      ];
      # }}}

      # {{{ Extensions
      enabledExtensions = with spicePkgs.extensions;
      [
        adblock
        aiBandBlocker
        autoSkip
        copyLyrics
        copyToClipboard
        fullAlbumDate
        goToSong
        groupSession
        history
        lastfm
        listPlaylistsWithSong
        playingSource
        playlistIcons
        playlistIntersection
        queueTime
        savePlaylists
        seekSong
        showQueueDuration
        shuffle
        skipStats
        sleepTimer
        songStats
        #sortPlay
        wikify
      ];
      # }}}

      theme       = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    custom.nix.unfreeWhitelist = [ "spotify" ];
  };
}
