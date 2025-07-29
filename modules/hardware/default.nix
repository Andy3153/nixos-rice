## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hardware bundle
##

{ lib, ... }:

{
  imports =
  [
    ./bluetooth.nix
    ./controllers.nix
    ./gpuDrivers.nix
    ./gpuPassthrough.nix
    ./graphics.nix
    ./graphictablets.nix
    ./i2c.nix
    ./laptop
    ./nvidia
    ./openrgb.nix
    ./piper.nix
    ./thunderbolt.nix
  ]
  ++
  lib.optionals (lib.versionOlder lib.version "24.11pre")
  [
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable" ] [ "hardware" "opengl" "enable" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages" ] [ "hardware" "opengl" "extraPackages" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages32" ] [ "hardware" "opengl" "extraPackages32" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable32Bit" ] [ "hardware" "opengl" "driSupport32Bit" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package" ] [ "hardware" "opengl" "package" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package32" ] [ "hardware" "opengl" "package32" ])
  ];
}
