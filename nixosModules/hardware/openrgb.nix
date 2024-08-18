## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenRGB config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.openrgb;

  # {{{ OpenRGB derivation
  openrgbPackage = pkgs.openrgb-with-all-plugins.overrideAttrs (_:
  {
    version = "0.91";

    src = pkgs.fetchFromGitLab
    {
      owner  = "CalcProgrammer1";
      repo   = "OpenRGB";
      rev    = "6e66c6ff5e9ec181fc53a8831c391258f9d2c980";
      sha256 = "sha256-VOtWbhCdzG8/XmaXDKIoI02454RwKke68PRn5lvmQlY=";
    };

    postPatch =
    ''
      patchShebangs scripts/build-udev-rules.sh
      substituteInPlace scripts/build-udev-rules.sh \
        --replace "/usr/bin/env chmod" "${lib.getExe' pkgs.coreutils "chmod"}"
    '';
  });
  # }}}
in
{
  options.custom.hardware.openrgb.enable = lib.mkEnableOption "enables OpenRGB";

  config = lib.mkIf cfg.enable
  {
    custom.hardware.i2c.enable = lib.mkForce true; # force enable custom i2c

    #custom.extraPackages  = [ pkgs.openrgb-plugin-effects ];
    services.udev.packages = [ openrgbPackage ];

    services.hardware.openrgb =
    {
      enable  = true;
      package = openrgbPackage;
    };
  };
}
