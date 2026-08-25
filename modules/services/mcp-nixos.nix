## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## MCP-NixOS config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.services.mcp-nixos;
in
# }}}
{
  # {{{ Options
  options.custom.services.mcp-nixos =
  {
    enable       = lib.mkEnableOption "enables MCP-NixOS";
    enableOnBoot = lib.mkEnableOption "start MCP-NixOS at boot";

    host = lib.mkOption
    {
      type        = lib.types.str;
      default     = "127.0.0.1";
      example     = "0.0.0.0";
      description = "IP address on which the server should listen on";
    };

    port = lib.mkOption
    {
      type        = lib.types.port;
      default     = 9932;
      example     = 1337;
      description = "port on which the server should listen on";
    };
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    systemd.services.mcp-nixos =
    {
      description = "MCP-NixOS HTTP server";
      after       = [ "network.target" ];
      wantedBy    = lib.mkIf cfg.enableOnBoot [ "multi-user.target" ];
      wants       = [ "network.target" ];

      environment =
      {
        MCP_NIXOS_TRANSPORT = "http";
        MCP_NIXOS_HOST      = cfg.host;
        MCP_NIXOS_PORT      = builtins.toString cfg.port;
      };

      serviceConfig =
      {
        Restart    = "on-failure";
        RestartSec = 300;
        ExecStart  = lib.getExe pkgs.mcp-nixos;

        # {{{ Hardening
        ##
        ## Copied from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/misc/llama-cpp.nix
        ##

        DynamicUser             = true;
        StateDirectory          = "mcp-nixos";
        CacheDirectory          = "mcp-nixos";
        WorkingDirectory        = "/var/lib/mcp-nixos";
        AmbientCapabilities     = [ "" ];
        CapabilityBoundingSet   = [ "" ];
        LockPersonality         = true;
        MemoryDenyWriteExecute  = true;
        NoNewPrivileges         = true;
        PrivateDevices          = true;
        PrivateMounts           = true;
        PrivateTmp              = true;
        PrivateUsers            = true;
        ProcSubset              = "pid";
        ProtectClock            = true;
        ProtectControlGroups    = true;
        ProtectHome             = true;
        ProtectHostname         = true;
        ProtectKernelLogs       = true;
        ProtectKernelModules    = true;
        ProtectKernelTunables   = true;
        ProtectProc             = "invisible";
        ProtectSystem           = "strict";
        RemoveIPC               = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces      = true;
        RestrictRealtime        = true;
        RestrictSUIDSGID        = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber   = "EPERM";
        SystemCallFilter        = [ "@system-service" "~@privileged" ];
        # }}}
      };
    };
  };
  # }}}
}
