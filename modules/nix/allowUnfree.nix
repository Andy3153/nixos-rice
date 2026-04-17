## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Allow unfree globally config
##

{ config, lib, ... }:

let
  cfg = config.custom.nix.allowUnfree;
in
{
  options.custom.nix.allowUnfree = lib.mkOption
  {
    type        = lib.types.bool;
    default     = false;
    example     = true;
    description = "global switch for unfree packages";
  };

  config.nixpkgs.config.allowUnfree = cfg;
}
