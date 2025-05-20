## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## ZeroTier One config
##

{ config, lib, ... }:

let
  cfg = config.custom.services.zerotierone;
in
{
  options.custom.services.zerotierone.enable = lib.mkEnableOption "enables ZeroTier One";

  config = lib.mkIf cfg.enable
  {
    services.zerotierone.enable = true;
    custom.nix.unfreeWhitelist  = [ "zerotierone" ];
  };
}
