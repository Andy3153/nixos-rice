## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Steven Black's hostfile config
##

{ config, lib, ... }:

let
  cfg = config.custom.networking.stevenblack;
in
{
  options.custom.networking.stevenblack.enable = lib.mkEnableOption "enable Steven Black's hostfile blocklist";

  config = lib.mkIf cfg.enable
  {
    networking.stevenblack.enable = true;
  };
}
