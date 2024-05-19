## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Quiet boot config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.boot.quiet;
in
{
  options =
  {
    custom.boot.quiet = lib.mkEnableOption "enables quiet boot";
  };

  config = lib.mkIf module
  {
    boot =
    {
      consoleLogLevel = 0;

      kernelParams =
      [
        "quiet"
        "udev.log_level=0"
      ];

      initrd.verbose = false;
    };
  };
}
