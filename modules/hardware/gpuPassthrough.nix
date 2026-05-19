## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GPU passthrough config
##

{ config, options, lib, ... }:

let
  cfg      = config.custom.hardware.gpuPassthrough;
  mainUser = config.custom.users.mainUser;
in
{
  # {{{ Options
  options =
  {
    custom.hardware.gpuPassthrough =
    {
      enable = lib.mkEnableOption "enables GPU passthrough";

      cpu = lib.mkOption
      {
        type        = lib.types.enum [ "intel" "amd" ];
        example     = "intel";
        description = "the manufacturer of the CPU of the machine";
      };

      gpu = lib.mkOption
      {
        type        = lib.types.enum [ "nvidia" ];
        example     = "nvidia";
        description = "the manufacturer of the GPU that gets passed through";
      };

      gpuIDs = lib.mkOption
      {
        type        = lib.types.listOf lib.types.str;
        example     = [ "10de:2520" "10de:228e" ]; # 3060 mobile
        description = "the PCI bus IDs of the GPU components (GPU itself and audio board) to be passed through";
      };
    };

    virtualisation.libvirtd.deviceACL = lib.mkOption # compatibility with `nixos-vfio/modules/kvmfr`
    {
      type        = lib.types.listOf lib.types.str;
      default     = [ ];
      description = "allowed devices";
    };
  };
  # }}}

  config = lib.mkIf cfg.enable
  {
    boot =
    {
      initrd.kernelModules = lib.mkMerge
      [
        [ "vfio_virqfd" ]

        (lib.mkIf (cfg.gpu == "nvidia")
        [
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
          "nvidia_uvm"
        ])
      ];

      kernelParams = [ "iommu=pt" ];
    };

    virtualisation =
    {
      # {{{ KVMFR
      kvmfr =
      {
        enable = true;
        devices =
        [
          {
            permissions = rec
            {
              user  = mainUser;
              group = user;
            };

            resolution =
            {
              width  = 1920;
              height = 1080;
            };
          }
        ];
      };
      # }}}

      # {{{ VFIO
      vfio =
      {
        enable    = true;
        IOMMUType = cfg.cpu;
        devices   = cfg.gpuIDs;
      };
      # }}}

      # {{{ Libvirtd
      libvirtd.qemu.verbatimConfig = # compatibility with `nixos-vfio/modules/kvmfr`
      #let
      #  deviceACL = config.virtualisation.libvirtd.deviceACL;
      #  aclString = with lib.strings; concatMapStringsSep ",\n" escapeNixString deviceACL;
      #in
      #''
      #  namespaces = []
      #  cgroup_device_acl = [
      #    ${aclString}
      #  ]
      #'';
      ''
        namespaces = []
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/rtc", "/dev/hpet",
          "/dev/vfio/devices/vfio0", "/dev/vfio/devices/vfio1",
          "/dev/kvmfr0"
        ]
      '';
      # }}}
    };

    custom =
    {
      hardware.graphics.enable      = true;
      programs.looking-glass.enable = true;

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "nvidia-kernel-modules"
        "nvidia-settings"
        "nvidia-x11"
      ];
      # }}}
    };
  };
}
