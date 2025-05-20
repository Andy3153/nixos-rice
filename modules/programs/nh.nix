## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nh config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.nh;

  mainUser = config.custom.users.mainUser;
  HM       = config.home-manager.users.${mainUser};
  homeDir  = HM.home.homeDirectory;
in
{
  options.custom.programs.nh.enable = lib.mkOption
  {
    type        = lib.types.bool;
    default     = true;
    example     = false;
    description = "enables Nh";
  };

  config = lib.mkIf cfg.enable
  {
    programs.nh =
    {
      enable = true;
      flake = "${homeDir}/src/nixos/nixos-rice";
      clean =
      {
        enable    = true;
        dates     = "weekly";
        extraArgs = "--keep 2 --keep-since 2d";
      };
    };
  };
}
