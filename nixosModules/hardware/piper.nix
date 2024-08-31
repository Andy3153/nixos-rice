## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Piper & ratbagd config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.piper;

  # {{{ ratbagd derivation
  ratbagdPackage = pkgs.libratbag.overrideAttrs (_:
  {
    version = "0.18";

    src = pkgs.fetchFromGitHub
    {
      owner = "libratbag";
      repo  = "libratbag";
      rev   = "1c9662043f4a11af26537e394bbd90e38994066a";
      hash  = "sha256-IpN97PPn9p1y+cAh9qJAi5f4zzOlm6bjCxRrUTSXNqM=";
    };
  });
  # }}}

  # {{{ Piper derivation
  piperPackage = pkgs.piper.overrideAttrs (_:
  {
    version = "0.8";

    src = pkgs.fetchFromGitHub
    {
      owner = "libratbag";
      repo  = "piper";
      rev   = "93a5a004766e37a801940cc3317c4aea9d2a6cfd";
      hash  = "sha256-a+HBxFYzRfcLPR7Ut+sFEh9Aj8b+Xbqhp6TGGCVbCb8=";
    };

    mesonFlags = [ "-Druntime-dependency-checks=false" ];
  });
  # }}}
in
{
  options.custom.hardware.piper.enable = lib.mkEnableOption "enables Piper & ratbagd";

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = [ piperPackage ];
    services.ratbagd =
    {
      enable  = true;
      package = ratbagdPackage;
    };
  };
}
