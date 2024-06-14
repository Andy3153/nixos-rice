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
      enable = lib.mkEnableOption "enables Docker";
      enableOnBoot = lib.mkOption
        {
          type = lib.types.bool;
          default = true;
          example = false;
          description = "whether enabled dockerd is started on boot.";
        };
    };

  config = lib.mkMerge
    [
      (lib.mkIf cfg.enable
        {
          virtualisation.docker =
            {
              enable = lib.mkDefault true;
              autoPrune.enable = lib.mkDefault true;
            };
        })

      (lib.mkIf (!cfg.enableOnBoot) { virtualisation.docker.enableOnBoot = lib.mkDefault false; })
    ];
}
