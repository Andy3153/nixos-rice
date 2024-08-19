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
      rev    = "428355761e43d47b8a2082fb0c369b931cf5c717";
      sha256 = "sha256-e3QEHfJUXX24PGkVwYhJUV2JJj9mqE1K+W0Q/HIdjAw=";
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
