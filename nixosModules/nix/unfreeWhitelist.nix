## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Unfree package whitelist config
##

{ config, lib, ... }:

let
  cfg = config.custom.nix.unfreeWhitelist;
in
{
  options.custom.nix.unfreeWhitelist = lib.mkOption
  {
    type        = lib.types.listOf lib.types.str;
    default     = [ ];
    example     = [ "steam" ];
    description = "unfree packages to be allowed in the system configuration";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) cfg;
}
