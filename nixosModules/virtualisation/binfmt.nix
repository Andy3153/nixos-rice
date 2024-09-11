## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Binfmt config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.virtualisation.binfmt.emulatedSystems;
in
{
  options.custom.virtualisation.binfmt.emulatedSystems = lib.mkOption
  {
    type        = options.boot.binfmt.emulatedSystems.type;
    default     = [ ];
    example     = [ "aarch64-linux" ];
    description = "list of systems to emulate. Any change requires a reboot";
  };

  config.boot.binfmt.emulatedSystems = cfg;
}
