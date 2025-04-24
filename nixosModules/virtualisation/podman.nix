## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Podman config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.virtualisation.podman;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.virtualisation.podman.enable = lib.mkEnableOption "enables Podman";

  config = lib.mkIf cfg.enable
  {
    virtualisation.podman =
    {
      enable              = true;
      autoPrune.enable    = true;
      dockerCompat        = !config.custom.virtualisation.docker.enable;
      dockerSocket.enable = !config.custom.virtualisation.docker.enable;
    };

    users.users.${mainUser}.extraGroups = [ "podman" ];

    custom.extraPackages = with pkgs; [ podman-compose ];
  };
}
