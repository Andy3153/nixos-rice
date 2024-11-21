## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nix package config
##

{ config, lib, options, inputs, pkgs, ... }:

let
  cfg = config.custom.nix.package;
  sys = pkgs.stdenv.hostPlatform.system;
in
{
  options.custom.nix.package = lib.mkOption
  {
    type        = options.nix.package.type;
    #default     = inputs.in-nix.packages.${sys}.default.patchNix pkgs.nix;
    default     = options.nix.package.default;
    description = "Nix package";
  };

  config.nix.package = cfg;
}
