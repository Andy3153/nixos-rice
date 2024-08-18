## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## SSH config
##

{ config, lib, ... }:

let
  cfg      = config.custom.programs.ssh;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.ssh =
  {
    enable = lib.mkEnableOption "enables SSH";
    matchBlocks = lib.mkOption
    {
      type = lib.types.anything;
    };
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      programs.ssh =
      {
        enable      = true;
        matchBlocks = cfg.matchBlocks;
      };
    };
    # }}}
  };
}
