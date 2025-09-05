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
    type        = lib.types.enum [ "nix" "detsys-nix" "lix" ];
    #default     = options.nix.package.default;
    #default     = inputs.in-nix.packages.${sys}.default.patchNix pkgs.nix;
    default     = "detsys-nix";
    example     = "nix";
    description = "Nix package";
  };

  config =
  {
    determinate.enable = if cfg == "detsys-nix" then true else false;
    nix.settings = lib.mkIf (cfg == "detsys-nix")
    {
      always-allow-substitutes = false;
      #eval-cores = 0;
      lazy-trees = true;
    };

    nix.package =
      if builtins.isString cfg then
        if      cfg == "nix" then options.nix.package.default
        else if cfg == "lix" then pkgs.lixPackageSets.stable.lix
        else lib.mkDefault options.nix.package.default
      else lib.mkDefault cfg;

    nixpkgs.overlays =
      if builtins.isString cfg then
        if cfg == "lix" then
          [
            (final: prev:
            {
              inherit (final.lixPackageSets.stable)
                nixpkgs-review
                #nix-direnv
                nix-eval-jobs
                nix-fast-build
                colmena;
            })
          ]
        else []
      else [];
  };
}
