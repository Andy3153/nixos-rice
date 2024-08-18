## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Docker config
##

{ config, lib, ... }:

let
  cfg = config.custom.virtualisation.docker;
in
{
  options.custom.virtualisation.docker =
  {
    enable          = lib.mkEnableOption "enables Docker";
    enableOnBoot    = lib.mkEnableOption "whether enabled dockerd is started on boot.";
    rootless.enable = lib.mkEnableOption "enable Docker in a rootless mode";
  };

  config = lib.mkIf cfg.enable
  {
    virtualisation.docker =
    {
      enable           = true;
      autoPrune.enable = true;
      enableOnBoot     = cfg.enableOnBoot;
      rootless.enable  = cfg.rootless.enable;
    };
  };
}
