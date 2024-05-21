## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Flatpak config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.services.flatpak;
in
{
  options.custom.services.flatpak.enable = lib.mkEnableOption "enables Flatpak";

  config = lib.mkIf cfg.enable
  {
    services.flatpak =
    {
      enable = lib.mkDefault true;

      overrides.global =
      {
        Context.filesystems =
        [
          "$HOME/.local/share/icons:ro"
          "$HOME/.local/share/themes:ro"
          "$HOME/.local/share/fonts:ro"
          "/nix/store:ro"
        ];

        Environment =
        {
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
    };
  };
}
