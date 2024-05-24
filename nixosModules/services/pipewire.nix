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
    services.pipewire =
    {
      enable            = lib.mkDefault true;
      alsa.enable       = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable      = lib.mkDefault true;
    };
  };
}
