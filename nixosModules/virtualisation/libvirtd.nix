## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Libvirtd config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.virtualisation.libvirtd;
in
{
  options.custom.virtualisation.libvirtd.enable = lib.mkEnableOption "enables Libvirtd";

  config = lib.mkIf cfg.enable
  {
    virtualisation.libvirtd =
    {
      enable     = lib.mkDefault true;
      onBoot     = lib.mkDefault "ignore";
      onShutdown = lib.mkDefault "suspend";

      qemu =
      {
        runAsRoot    = lib.mkDefault false;
        swtpm.enable = lib.mkDefault true;
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
