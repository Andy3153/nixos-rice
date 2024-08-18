## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Custom NixOS modules bundle
##

{ config, options, lib, ... }:

let
  cfg = config.custom;

  # {{{ Flatpak package options
  packageOptions = _:
  {
    options =
    {
      appId = lib.mkOption
      {
        type        = lib.types.str;
        description = "the app ID of the app to install";
      };

      commit = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        description = "hash of the app commit to install";
      };

      origin = lib.mkOption
      {
        type        = lib.types.str;
        default     = "flathub";
        description = "repository origin (default: flathub)";
      };
    };
  };
  # }}}
in
{
  imports =
  [
    ./common.nix
    ./boot
    ./gui
    ./hardware
    ./networking
    ./programs
    ./services
    ./systemd
    ./users
    ./virtualisation
    ./xdg
  ];

  options.custom =
  {
    extraPackages = lib.mkOption
    {
      type        = options.environment.systemPackages.type;
      default     = [ ];
      description = "extra packages to add to the configuration";
    };

    extraFlatpakPackages = lib.mkOption
    {
      type        = options.services.flatpak.packages.type;
      default     = [ ];
      description = "extra flatpak packages to add to the configuration";
    };
  };

  config =
  {
    environment.systemPackages = cfg.extraPackages;
    custom.services.flatpak =
    {
      enable   = lib.mkIf cfg.extraFlatpakPackages != [ ];
      packages = cfg.extraFlatpakPackages;
    };
  };
}
