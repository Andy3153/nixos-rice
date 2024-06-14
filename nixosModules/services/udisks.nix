## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## udisks config
##

{ config, lib, ... }:

let
  cfg = config.custom.services.udisks2;
in
{
  options.custom.services.udisks2.enable = lib.mkEnableOption "enables UDisks (get drives in Dolphin)";

  config = lib.mkIf cfg.enable
    {
      services.udisks2.enable = lib.mkDefault true;
    };
}
