## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Extra packages config
##

{ config, options, lib, ... }:

let
  cfg = config.custom;
in
{
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
