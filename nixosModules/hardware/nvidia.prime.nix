## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nvidia PRIME render offload config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.nvidia.prime;
in
{
  options =
  {
    custom.hardware.nvidia.prime.enable = lib.mkEnableOption "enables Nvidia PRIME render offloading";
  };

  config = lib.mkIf module.enable
  {
    hardware.nvidia =
    {
      prime.offload =
      {
        enable           = true;
        enableOffloadCmd = true;
      };
    };
  };
}
