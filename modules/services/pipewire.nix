## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## PipeWire config
##

{ config, lib, ... }:

let
  cfg = config.custom.services.pipewire;
in
{
  options.custom.services.pipewire.enable = lib.mkEnableOption "enables PipeWire";

  config = lib.mkIf cfg.enable
  {
    security.rtkit.enable = lib.mkForce true; # pipewire wants it

    services.pipewire =
    {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
    };
  };
}
