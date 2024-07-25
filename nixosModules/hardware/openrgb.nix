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
      rev    = "9c7aad82594b49a132ce3a6b91b41a15c14c537a";
      sha256 = "sha256-jIH1fHGwngAbY7x8IyGC12OSKvY3cRnRoojYv4SqD9Y=";
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

    #environment.systemPackages = [ pkgs.openrgb-plugin-effects ];
    services.udev.packages     = [ openrgbPackage ];

    services.hardware.openrgb =
    {
      enable  = lib.mkDefault true;
      package = openrgbPackage;
    };
  };
}
