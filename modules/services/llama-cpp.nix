## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Llama.CPP config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.services.llama-cpp;

  mainUser            = config.custom.users.mainUser;
  mainUserCfg         = config.users.users.${mainUser};
  mainUserHome        = mainUserCfg.home;

  # {{{ Package
  llama-cppPkg = (pkgs.llama-cpp.override
  {
    blasSupport = true;
    cudaSupport = config.custom.hardware.nvidia.enable;
    rocmSupport = false;
  }).overrideAttrs (oldAttrs:
  {
    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ "-DGGML_NATIVE=ON" ];
    preConfigure =
    ''
      export NIX_ENFORCE_NO_NATIVE=0
      ${oldAttrs.preConfigure or ""}
    '';
  });
  # }}}

  # {{{ UI config file
  ##
  ## https://github.com/ggml-org/llama.cpp/blob/master/tools/ui/src/lib/constants/settings.constants.ts
  ##

  uiConfigFile = (pkgs.formats.json { }).generate "llamacpp-ui-config-file.json"
  {
    alwaysShowSidebarOnDesktop  = true;
    autoMicOnEmpty              = true;
    #disableAutoScroll           = true;
    enableContinueGeneration    = true;
    pasteLongTextToFileLen      = 5000;
    renderUserContentAsMarkdown = true;
    showBuildVersion            = true;
    theme                       = "dark";
  };
  # }}}
in
# }}}
{
  # {{{ Options
  options.custom.services.llama-cpp =
  {
    enable = lib.mkEnableOption "enables Llama.CPP";

    models = lib.mkOption
    {
      type        = lib.types.attrs;
      default     = { };
      example     =
      {
        "Qwen3.5-9B" =
        {
          hf-repo = "unsloth/Qwen3.5-9B-GGUF";
          hf-file = "Qwen3.5-9B-UD-Q4_K_XL.gguf";
          alias   = "Qwen3.5-9B";
          temp    = "0.6";
          top-p   = "0.95";
          top-k   = "20";
          min-p   = "0.00";
          jinja   = "on";
        };
      };
      description = "models to have available";
    };
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    # {{{ Unfree whitelist
    custom.nix.unfreeWhitelist =
    [
      "cuda_cccl"
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_nvrtc"
      "libcublas"
    ];
    # }}}

    # {{{ Llama.CPP
    services.llama-cpp =
    {
      enable  = true;
      package = llama-cppPkg;

      # {{{ Settings
      settings =
      {
        cache-type-k   = "q8_0";
        cache-type-v   = "q8_0";
        ctx-size       = 65536;
        models-max     = 1;
        models-preset  = (pkgs.formats.ini { }).generate "llamacpp-models-preset.ini" cfg.models;
        no-kv-offload  = true;
        port           = 9931;
        tools          = "read_file,file_glob_search,grep_search,get_datetime,get_info";
        ui-config-file = uiConfigFile;
        ui-mcp-proxy   = true;
      };
      # }}}
    };
    # }}}

    # {{{ Systemd
    systemd =
    {
      # {{{ Llama.CPP service
      services.llama-cpp =
      {
        serviceConfig =
        {
          PrivateUsers        = lib.mkForce false;
          ProtectHome         = lib.mkForce "read-only";
          ProtectHostname     = lib.mkForce false;
          SupplementaryGroups = "llama-cpp_homediraccess";
          WorkingDirectory    = lib.mkForce mainUserHome;
        };

        wantedBy = lib.mkForce [ ]; # disable on boot
      };
      # }}}

      # {{{ Systemd tmpfiles rules
      tmpfiles.rules = [ "a+ ${mainUserHome} - - - - mask::r-x,group:llama-cpp_homediraccess:r-x" ];
      # }}}
    };
    # }}}

    # {{{ Groups
    users.groups.llama-cpp_homediraccess = { };
    # }}}
  };
  # }}}
}
