## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Ollama config
##

{ config, options, lib, ... }:

let
  cfg    = config.custom.services.ollama;
  nvidia = config.custom.hardware.nvidia.enable;
in
{
  options.custom.services.ollama =
  {
    enable = lib.mkEnableOption "enables Ollama and Open WebUI";

    models = lib.mkOption
    {
      type        = options.services.ollama.loadModels;
      default     = [ ];
      example     = [ "deepseek-r1:14b" ];
      description = "what models to download by default";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services =
    {
      ollama =
      {
        enable       = true;
        acceleration = lib.mkIf nvidia "cuda";
        loadModels   = cfg.models;
      };

      open-webui.enable = true;
    };
  };
}
