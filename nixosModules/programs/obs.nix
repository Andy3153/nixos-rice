## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OBS config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.obs;
in
{
  options.custom.programs.obs.enable = lib.mkEnableOption "enables OBS";

  config = lib.mkIf cfg.enable
  {
    boot =
    {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1'';
    };
  };
}
