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

  config = lib.mkIf cfg.enable
  {
    custom.hardware.nvidia.enable = true; # force enable custom nvidia

    hardware.nvidia.prime.offload =
    {
      enable           = true;
      enableOffloadCmd = true;
    };
  };
}
