## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## systemd-boot config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.loader.systemd-boot;
in
{
  options.custom.boot.loader.systemd-boot =
  {
    enable           = lib.mkEnableOption "enables systemd-boot";
    memtest86.enable = lib.mkEnableOption "enables memtest86";
  };

  config = # no lib.mkIf because Lanzaboote takes options from systemd-boot config
  {
    boot.loader =
    {
      grub.enable = lib.mkIf cfg.enable false;

      systemd-boot =
      {
        enable           = cfg.enable;
        editor           = false;
        memtest86.enable = cfg.memtest86.enable;
      };
    };
  };
}
