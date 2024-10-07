## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Looking Glass config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.programs.looking-glass;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.looking-glass.enable = lib.mkEnableOption "enables Looking Glass";
  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = [ pkgs.looking-glass-client ];

    systemd.tmpfiles.settings."10-looking-glass.conf"."/dev/shm/looking-glass".f =
    {
      mode  = "0660";
      user  = mainUser;
      group = "kvm";
    };
  };
}
