## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Extra hosts config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.networking.extraHosts;
in
{
  options.custom.networking.extraHosts = lib.mkOption
  {
    type        = options.networking.extraHosts.type;
    default     = "";
    description = "entries to be added to `/etc/hosts`";
  };

  config =
  {
    networking.extraHosts = cfg;
  };
}
