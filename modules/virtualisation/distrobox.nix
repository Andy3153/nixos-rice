## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Distrobox config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.virtualisation.distrobox;
in
{
  options.custom.virtualisation.distrobox.enable = lib.mkEnableOption "enables Distrobox";

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = with pkgs; [ distrobox ];

    assertions =
    [
      {
        assertion = cfg.enable -> (config.custom.virtualisation.docker.enable || config.custom.virtualisation.podman.enable);
        message = "Distrobox requires `custom.virtualisation.docker.enable` or `custom.virtualisation.podman.enable`";
      }
    ];
  };
}
