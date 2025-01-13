## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## VirtualBox config
##

{ config, lib, ... }:

let
  cfg = config.custom.virtualisation.virtualbox;
in
{
  options.custom.virtualisation.virtualbox.enable = lib.mkEnableOption "enables VirtualBox";

  config = lib.mkIf cfg.enable
  {
    virtualisation.virtualbox =
    {
      guest.enable = true;
      host =
      {
        enable              = true;
        enableExtensionPack = true;
        enableKvm           = true;
        addNetworkInterface = false;
      };
    };

    # {{{ Unfree package whitelist
    custom.nix.unfreeWhitelist =
    [
      "Oracle_VirtualBox_Extension_Pack"
    ];
    # }}}
  };
}
