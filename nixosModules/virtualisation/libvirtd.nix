## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Libvirtd config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.virtualisation.libvirtd;
in
{
  options =
  {
    custom.virtualisation.libvirtd.enable = lib.mkEnableOption "enables Libvirtd";
  };

  config = lib.mkIf module.enable
  {
    virtualisation.libvirtd =
    {
      enable     = true;
      onBoot     = "ignore";
      onShutdown = "suspend";

      qemu =
      {
        runAsRoot    = false;
        swtpm.enable = true;
      };
    };
  };
}
