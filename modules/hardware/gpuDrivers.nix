## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GPU drivers config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.hardware.gpuDrivers;
in
{
  options.custom.hardware.gpuDrivers = lib.mkOption
  {
    type        = options.services.xserver.videoDrivers.type;
    default     = options.services.xserver.videoDrivers.default;
    example =
    [
      "modesetting"
      "intel"
      "nvidia"
      "fbdev"
    ];
    description = "name of video drivers to install";
  };

  config = lib.mkIf (cfg != [ ]) { services.xserver.videoDrivers = cfg; };
}
