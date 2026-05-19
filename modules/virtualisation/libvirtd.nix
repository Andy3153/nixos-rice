## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Libvirtd config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.virtualisation.libvirtd;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.virtualisation.libvirtd.enable = lib.mkEnableOption "enables Libvirtd";

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = [ pkgs.virtiofsd ];

    programs.virt-manager.enable = true;

    virtualisation =
    {
      libvirtd =
      {
        enable = true;

        dbus.enable = true;

        onBoot     = "ignore";
        onShutdown = "suspend";

        qemu =
        {
          package           = pkgs.qemu_kvm;
          swtpm.enable      = true;
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      spiceUSBRedirection.enable = true;
    };

    users.users.${mainUser}.extraGroups = [ "libvirtd" ];

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      dconf.settings =
      {
        "org/virt-manager/virt-manager/connections" =
        {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
    # }}}
  };
}
