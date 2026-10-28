## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Plymouth config
##

{ config, options, lib, my-pkgs, ... }:

let
  cfg = config.custom.boot.plymouth;
in
{
  options.custom.boot.plymouth =
  {
    enable = lib.mkEnableOption "enables Plymouth";

    theme =
    {
      name = lib.mkOption
      {
        type        = options.boot.plymouth.theme.type;
        default     = "spinnerv2";
        example     = "spinner";
        description = "name of the Plymouth theme";
      };

      packages = lib.mkOption
      {
        type        = options.boot.plymouth.themePackages.type;
        default     = [ my-pkgs.plymouth-spinnerv2-theme ];
        description = "packages that provide the Plymouth themes";
      };
    };
  };

  config = lib.mkIf cfg.enable
  {
    custom.boot.quiet = lib.mkForce true;

    boot.plymouth =
    {
      enable        = true;
      theme         = cfg.theme.name;
      themePackages = cfg.theme.packages;
    };
  } // (if lib.versionOlder lib.version "26.11pre"
  then { boot.initrd.systemd.enable = lib.mkForce true; }
  else { });
}
