## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG bundle
##

{ config, lib, ... }:

let
  cfg = config.custom.xdg;
in
{
  imports =
  [
    ./portal.nix
    ./mime.nix
    ./userDirs.nix
  ];

  options.custom.xdg.enable = lib.mkEnableOption "enables XDG";

  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      xdg.enable = lib.mkDefault cfg.enable;
    };
    # }}}
  };
}
