## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GPU passthrough config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.gpuPassthrough;
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
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ]

        (lib.mkIf (cfg.gpu == "nvidia")
        [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ])
      ];

      kernelParams = lib.mkMerge
      [
        (lib.mkIf (cfg.cpu == "intel") [ "intel_iommu=on" ])
        (lib.mkIf (cfg.cpu == "amd")   [ "amd_iommu=on" ])
        [ ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.gpuIDs) ]
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
