## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Reverse SSH tunnel systemd service config
##

{ config, options, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.services.reverseSshTunnel;
  opt = options.custom.systemd.services.reverseSshTunnel;
in
{
  # {{{ Options
  options.custom.systemd.services.reverseSshTunnel =
  {
    enable = lib.mkEnableOption "systemd service that configures a reverse SSH tunnel";

    # {{{ Remote
    remote =
    {
      address = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        example     = "example.tld";
        description = "remote server's address";
      };

      port = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.int;
        default     = null;
        example     = 8022;
        description = "remote server's local port to which `host.port`'s traffic gets forwarded to";
      };

      user = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        example     = "user";
        description = "remote server's user";
      };
    };
    # }}}

    # {{{ Host
    host =
    {
      address = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        example     = "example.lan";
        description = "host's address";
      };

      port = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.int;
        default     = null;
        example     = 22;
        description = "host's port from which traffic gets forwarded from";
      };
    };
    # }}}

    sshKeyPath = lib.mkOption
    {
      type        = lib.types.nullOr lib.types.path;
      default     = null;
      example     = /etc/keys/key;
      description = "SSH key to use when connecting to the remote";
    };

    user = lib.mkOption
    {
      type        = lib.types.nullOr lib.types.str;
      default     = null;
      example     = "user";
      description = "user to run service as";
    };

    group = lib.mkOption
    {
      type        = lib.types.str;
      default     = config.users.users.${cfg.user}.group;
      example     = "group";
      description = "group to run service as";
    };
  };
  # }}}

  config = lib.mkIf cfg.enable
  {
    systemd.services.reverseSshTunnel =
    {
      enable      = true;
      description = opt.enable.description;
      after       = [ "network-online.target" ];
      requires    = [ "network-online.target" ];
      wantedBy    = [ "multi-user.target" ];

      serviceConfig =
      {
        Restart    = "always";
        RestartSec = 5;

        User  = cfg.user;
        Group = cfg.group;

        ExecStart  = lib.strings.concatStringsSep " "
        [
          "${lib.getExe pkgs.openssh}"

          "-NTg"

          "-o ServerAliveInterval=30"
          "-o ExitOnForwardFailure=yes"

          (if (cfg.sshKeyPath != null)
          then "-i ${cfg.sshKeyPath}"
          else "")

          "-R ${builtins.toString cfg.remote.port}:${cfg.host.address}:${builtins.toString cfg.host.port}"

          (if (cfg.remote.user != null)
          then "${cfg.remote.user}@${cfg.remote.address}"
          else "${cfg.remote.address}")
        ];
      };
    };
  };
}
