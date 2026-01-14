## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## ADB config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.programs.adb;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.adb.enable = lib.mkEnableOption "enables ADB";
  config = lib.mkIf cfg.enable
  {
    custom.extraPackages                = [ pkgs.android-tools ];
    users.users.${mainUser}.extraGroups = [ "adbusers" ];
  };
}
