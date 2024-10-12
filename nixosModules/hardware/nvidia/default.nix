## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nvidia bundle
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.nvidia;
in
{
  imports =
  [
    ./prime.nix
  ];

  options.custom.hardware.nvidia.enable = lib.mkEnableOption "enables Nvidia";

  config = lib.mkIf cfg.enable
  {
    boot =
    {
      extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
      kernelModules = [ "nvidia_uvm" ];
    };

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
  };
}
