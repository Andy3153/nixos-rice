## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Fingerprint config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.hardware.fingerprint;
in
{
  options.custom.hardware.fingerprint =
  {
    enable = lib.mkEnableOption "enables fingerprint support";
    driver = lib.mkOption
    {
      type        = lib.types.anything;
      default     = null;
      example     = "pkgs.libfprint-2-tod1-goodix";
      description = "Touch OEM Drivers package to use";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.fprintd =
    {
      enable = true;

      tod =
      {
        enable = lib.mkIf (cfg.driver != null) true;
        driver = cfg.driver;
      };
    };
  };
}
