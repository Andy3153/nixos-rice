## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Libvirtd config
##

{ config, lib, ... }:

let
  cfg      = config.custom.virtualisation.libvirtd;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.virtualisation.libvirtd.enable = lib.mkEnableOption "enables Libvirtd";

  config = lib.mkIf cfg.enable
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

    virtualisation.spiceUSBRedirection.enable = true;

    users.users.${mainUser}.extraGroups = [ "libvirtd" ];

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
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
