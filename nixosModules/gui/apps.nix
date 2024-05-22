## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI apps config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui.apps;
in
{
  options.custom.gui.apps.enable = lib.mkEnableOption "enables the default programs desired in a gui";

  config = lib.mkIf cfg.enable
  {
    services.flatpak.packages =
    [
      "com.github.tchx84.Flatseal"         # Base-System
      "io.gitlab.librewolf-community"      # Browsers
      "com.brave.Browser"                  # Browsers
      "org.torproject.torbrowser-launcher" # Browsers Tor

      "com.discordapp.Discord"             # Social
      "io.github.trigg.discover_overlay"   # for-discord
      "org.ferdium.Ferdium"                # Social

      "com.spotify.Client"                 # Music-Players

      "sh.ppy.osu"                         # Games
    ];
  };
}
