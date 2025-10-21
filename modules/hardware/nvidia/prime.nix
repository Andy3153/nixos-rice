## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nvidia PRIME config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.nvidia.prime;
in
{
  options.custom.hardware.nvidia.prime.enable = lib.mkEnableOption "enables Nvidia PRIME render offloading";

  config =
  {
    hardware.nvidia.prime.offload =
    {
      enable           = cfg.enable;
      enableOffloadCmd = cfg.enable;
    };
  };
}
