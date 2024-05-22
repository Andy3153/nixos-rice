## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Kernel config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.kernel;
in
{
  options.custom.boot.kernel = lib.mkOption
  {
    type        = lib.types.raw;
    default     = pkgs.linuxPackages;
    example     = pkgs.linuxKernel.packages.linux_zen;
    description = "what Linux kernel to use";
  };

  config.boot.kernelPackages = cfg;
}
