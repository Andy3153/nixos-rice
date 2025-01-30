## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Initial ramdisk config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.initrd;
in
{
  options.custom.boot.initrd.systemd.enable = lib.mkOption
  {
    type        = lib.types.bool;
    default     = true;
    example     = false;
    description = "enables systemd in the initial ramdisk";
  };

  config.boot.initrd.systemd.enable = cfg.systemd.enable;
}

