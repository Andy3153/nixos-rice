## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Llama.CPP config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.services.llama-cpp;

  mainUser     = config.custom.users.mainUser;
  mainUserCfg  = config.users.users.${mainUser};
  mainUserHome = mainUserCfg.home;

  # {{{ Package
  llama-cppPkg = (pkgs.llama-cpp.override
  {
    blasSupport   = cfg.acceleration.blas;
    cudaSupport   = cfg.acceleration.cuda;
    rocmSupport   = false;
    vulkanSupport = cfg.acceleration.vulkan;
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
in
# }}}
{
  # {{{ Options
  options.custom.services.llama-cpp =
  {
    enable       = lib.mkEnableOption "enables Llama.CPP";
    enableOnBoot = lib.mkEnableOption "start Llama.CPP at boot";

    # {{{ Acceleration
    acceleration =
    {
      blas = lib.mkOption
      {
        type        = lib.types.bool;
        default     = true;
        example     = false;
        description = "enable BLAS acceleration";
      };

      cuda = lib.mkOption
      {
        type        = lib.types.bool;
        default     = config.custom.hardware.nvidia.enable;
        example     = true;
        description = "enable CUDA acceleration";
      };

      vulkan = lib.mkOption
      {
        type        = lib.types.bool;
        default     = !cfg.acceleration.cuda;
        example     = true;
        description = "enable Vulkan acceleration";
      };
    };
    # }}}

    # {{{ Host
    host = lib.mkOption
    {
      type        = lib.types.str;
      default     = "127.0.0.1";
      example     = "0.0.0.0";
      description = "IP address on which the server should listen on";
    };
    # }}}

    # {{{ MCP config
    mcpConfig = lib.mkOption
    {
      type = lib.types.attrs;

      default =
      {
        mcp-fetch.command = lib.getExe pkgs.mcp-server-fetch;
        mcp-git.command   = lib.getExe pkgs.mcp-server-git;
        mcp-gitea.command = lib.getExe pkgs.gitea-mcp-server;

        mcp-github =
        {
          args = [ "--read-only" "stdio" ];
          command = lib.getExe pkgs.github-mcp-server;
        };

        mcp-nixos.command               = lib.getExe pkgs.mcp-nixos;
        mcp-sequential-thinking.command = lib.getExe pkgs.mcp-server-sequential-thinking;
        mcp-time.command                = lib.getExe pkgs.mcp-server-time;
      };

      description = "MCP configuration (Cursor-compatible format)";
    };
    # }}}

    # {{{ Models
    models = lib.mkOption
    {
      type    = lib.types.attrs;
      default = { };

      example =
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
    # }}}

    # {{{ Port
    port = lib.mkOption
    {
      type        = lib.types.port;
      default     = 9931;
      example     = 1337;
      description = "port on which the server should listen on";
    };
    # }}}

    # {{{ UI config
    uiConfig = lib.mkOption
    {
      type = lib.types.attrs;

      default =
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

      description = "llama-ui default configuration (documentation at `https://github.com/ggml-org/llama.cpp/blob/master/tools/ui/src/lib/constants/settings.constants.ts`)";
    };
    # }}}
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
      ##
      ## https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md#usage
      ##

      settings = rec
      {
        cache-type-k       = "q8_0";
        cache-type-v       = "q8_0";
        ctx-size           = 65536;
        host               = cfg.host;
        mcp-servers-config = (pkgs.formats.json { }).generate "llamacpp-mcp-servers-config.json" { mcpServers = cfg.mcpConfig; };
        models-max         = 1;
        models-preset      = (pkgs.formats.ini { }).generate "llamacpp-models-preset.ini" cfg.models;
        no-kv-offload      = true;
        port               = cfg.port;
        tools              = "read_file,file_glob_search,grep_search,get_info";
        ui-config-file     = (pkgs.formats.json { }).generate "llamacpp-ui-config-file.json" cfg.uiConfig;
        ui-mcp-proxy       = true;
        webui-config-file  = ui-config-file;
        webui-mcp-proxy    = ui-mcp-proxy;
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
          ProtectClock        = lib.mkForce false;
          ProtectHome         = lib.mkForce "read-only";
          ProtectHostname     = lib.mkForce false;
          SupplementaryGroups = "llama-cpp_homediraccess";
          WorkingDirectory    = lib.mkForce mainUserHome;
        };

        wantedBy = lib.mkIf (!cfg.enableOnBoot) (lib.mkForce [ ]);
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
