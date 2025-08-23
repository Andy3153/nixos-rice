## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Dolphin config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.dolphin;
  workspacePkg = pkgs.kdePackages.plasma-workspace;
in
{
  options.custom.programs.dolphin.enable = lib.mkEnableOption "enables Dolphin";
  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = with pkgs.kdePackages;
    [
      dolphin
      kservice
    ];

    ##
    ## Fixes a bug which makes the "Open With" menu empty, at the expense of
    ## pulling the entirety of plasma-workspace inside of the nix store.
    ##
    ## https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/8
    ##
    environment.etc."/xdg/menus/applications.menu".text = builtins.readFile
     "${workspacePkg}/etc/xdg/menus/plasma-applications.menu";
  };
}
