## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nvidia config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.nvidia;
in
{
  options =
  {
    custom.hardware.nvidia.enable = lib.mkEnableOption "enables Nvidia";
  };

  config = lib.mkIf module.enable
  {
    boot.extraModulePackages           = [ config.boot.kernelPackages.nvidia_x11 ];
    hardware.nvidia.modesetting.enable = true;
    hardware.opengl.extraPackages      = [ pkgs.vaapiVdpau ];
    services.xserver.videoDrivers      = [ "nvidia" ];
    virtualisation.docker.enableNvidia = true;
  };
}
