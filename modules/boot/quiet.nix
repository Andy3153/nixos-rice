## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Quiet boot config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.quiet;
in
{
  options.custom.boot.quiet = lib.mkEnableOption "enables quiet boot";

  config = lib.mkIf cfg
  {
    boot =
    {
      consoleLogLevel = 0;

      kernelParams =
      [
        "quiet"
        "udev.log_level=0"
      ];
    };
  } // (if lib.versionOlder lib.version "26.11pre"
  then { boot.initrd.verbose = false; }
  else { });
}
