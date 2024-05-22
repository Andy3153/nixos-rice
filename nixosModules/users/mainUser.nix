## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Main user config
##

{ config, lib, pkgs, ... }:

{
  options.custom.users.mainUser = lib.mkOption
  {
    type        = lib.types.str;
    description = "the main user of this configuration";
    default     = "bot";
    example     = "andy3153";
  };

  config = lib.mkMerge
  [
    ({custom.users.mainUser = "andy3153";})
    (lib.mkIf (config.custom.users.mainUser == "andy3153") { custom.users.andy3153.enable = true; })
    (lib.mkIf (config.custom.users.mainUser == "bot")      { custom.users.bot.enable = true; })
  ];
}
