## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Andy3153 user config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.users.andy3153;
in
{
  options.custom.users.andy3153.enable = lib.mkEnableOption "enables Andy3153 user";

  config = lib.mkIf cfg.enable
  {
    users =
    {
      groups.andy3153 =
      {
        gid     = 3153;
        members = [ "andy3153" ];
      };

      users.andy3153 =
      {
        description     = "Andy3153";
        initialPassword = "sdfsdf";
        isNormalUser    = true;
        group           = "andy3153";
        shell           = pkgs.zsh;
        uid             = 3153;

        extraGroups =
        [
          "docker"
          "libvirtd"
          "wheel"
        ];
      };
    };
  };
}
