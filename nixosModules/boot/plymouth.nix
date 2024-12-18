## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Plymouth config
##

{ config, lib, my-pkgs, ... }:

let
  cfg = config.custom.boot.plymouth;
in
{
  options.custom.boot.plymouth.enable = lib.mkEnableOption "enables Plymouth";

  config = lib.mkIf cfg.enable
  {
    custom.boot.quiet = lib.mkForce true; # force enable quiet boot

    boot.plymouth =
    {
      enable = true;
      theme  = "spinnerv2";
      themePackages =
      [
        my-pkgs.plymouth-spinnerv2-theme
        #(pkgs.callPackage /home/andy3153/src/nixos/my-nixpkgs/pkgs/plymouth-spinnerv2-theme.nix { })
      ];
    };
  };
}
