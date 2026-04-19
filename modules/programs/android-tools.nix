## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Android tools config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.programs.android-tools;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.android-tools.enable = lib.mkEnableOption "enables Android tools";
  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = with pkgs;
    [
      android-tools  # android
      adbfs-rootless # android Filesystems FUSE
      scrcpy         # android screen-share
    ];
    users.users.${mainUser}.extraGroups = [ "adbusers" ];
  };
}
