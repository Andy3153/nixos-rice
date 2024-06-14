## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## systemd-boot config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.loader.systemd-boot;
in
{
  options.custom.boot.loader.systemd-boot =
    {
      enable = lib.mkEnableOption "enables systemd-boot";
      memtest86.enable = lib.mkEnableOption "enables memtest86";
    };

  config = lib.mkIf cfg.enable
    {
      boot.loader.systemd-boot =
        {
          enable = true;
          editor = false;
          memtest86.enable = cfg.memtest86.enable;

          # Rename boot entries
          extraInstallCommands = # thx @m0tholith on discord
            ''
              search_dir=/boot/loader/entries
              for file in "$search_dir"/*
              do
                ${lib.getExe pkgs.gnused} -i -E "s/version Generation ([0-9]+).*/version Gen \1/" $file
              done
            '';
        };
    };
}
