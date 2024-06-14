## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Timeout config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.loader.timeout;
in
{
  options.custom.boot.loader.timeout = lib.mkOption
    {
      type = lib.types.int;
      default = 0;
      example = 5;
      description = "timeout until loader boots the default menu item";
    };

  config.boot.loader.timeout = cfg;
}
