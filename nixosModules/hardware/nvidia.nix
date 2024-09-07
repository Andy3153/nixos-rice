## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nvidia config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.nvidia;
in
{
  options.custom.hardware.nvidia =
  {
    enable       = lib.mkEnableOption "enables Nvidia";
    prime.enable = lib.mkEnableOption "enables Nvidia PRIME render offloading";
  };

  config = lib.mkMerge
  [
    (lib.mkIf cfg.enable
    {
      boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

      hardware =
      {
        graphics.extraPackages    = [ pkgs.vaapiVdpau ];
        nvidia.modesetting.enable = true;
      };

      services.xserver.videoDrivers            = [ "nvidia" ];
      hardware.nvidia-container-toolkit.enable = lib.mkIf config.virtualisation.docker.enable true;

      custom =
      {
        extraPackages = [ pkgs.nvtopPackages.full ];

        # {{{ Unfree package whitelist
        nix.unfreeWhitelist =
        [
          "cuda-merged"
          "cuda_cccl"
          "cuda_cudart"
          "cuda_cuobjdump"
          "cuda_cupti"
          "cuda_cuxxfilt"
          "cuda_gdb"
          "cuda_nvcc"
          "cuda_nvdisasm"
          "cuda_nvml_dev"
          "cuda_nvprune"
          "cuda_nvrtc"
          "cuda_nvtx"
          "cuda_profiler_api"
          "cuda_sanitizer_api"
          "libcublas"
          "libcufft"
          "libcurand"
          "libcusolver"
          "libcusparse"
          "libnpp"
          "libnvjitlink"
          "nvidia-settings"
          "nvidia-x11"
        ];
        # }}}
      };
    })

    (lib.mkIf cfg.prime.enable
    {
      custom.hardware.nvidia.enable = lib.mkForce true; # force enable custom nvidia

      hardware.nvidia.prime.offload =
      {
        enable           = true;
        enableOffloadCmd = true;
      };
    })
  ];
}
