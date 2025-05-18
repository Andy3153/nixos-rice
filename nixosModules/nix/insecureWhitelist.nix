## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Insecure package whitelist config
##

{ config, lib, ... }:

let
  cfg = config.custom.nix.insecureWhitelist;
in
{
  options.custom.nix.insecureWhitelist = lib.mkOption
  {
    type        = lib.types.listOf lib.types.str;
    default     = [ ];
    example     = [ "ventoy-1.1.05" ];
    description = "insecure packages to be allowed in the system configuration";
  };

  config.nixpkgs.config.permittedInsecurePackages = cfg;
}
