## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GPU passthrough config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.hardware.gpuPassthrough;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.hardware.gpuPassthrough =
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

  config = lib.mkIf cfg.enable
  {
    boot =
    {
      initrd.kernelModules = lib.mkMerge
      [
        [
          "vfio"
          "vfio_iommu_type1"
          "vfio_pci"
          "vfio_virqfd"
        ]

        (lib.mkIf (cfg.gpu == "nvidia")
        [
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
          "nvidia_uvm"
        ])
      ];

      kernelParams = lib.mkMerge
      [
        (lib.mkIf (cfg.cpu == "intel") [ "intel_iommu=on" "iommu=pt" ])
        (lib.mkIf (cfg.cpu == "amd")   [ "amd_iommu=on"   "iommu=pt" ])
        [ ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.gpuIDs) ]
      ];
    };

    virtualisation.kvmfr =
    {
      enable = true;
      devices =
      [
        {
          resolution =
          {
            width  = 1920;
            height = 1080;
          };

          permissions = rec
          {
            user  = mainUser;
            group = user;
          };
        }
      ];
    };

    custom =
    {
      hardware.graphics.enable      = true;
      programs.looking-glass.enable = true;

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "nvidia-settings"
        "nvidia-x11"
      ];
      # }}}
    };
  };
}
