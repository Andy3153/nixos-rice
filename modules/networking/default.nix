## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Networking bundle
##

{ config, lib, ... }:

let
  persistPath = config.custom.filesystems.disk.main.partitions.main.subvolumes."/persist".mountpoint;
in
{
  imports =
  [
    ./extraHosts.nix
    ./stevenblack.nix
  ];

  networking.networkmanager =
  {
    enable = true;

    settings.keyfile.path =
      lib.mkIf (!(builtins.stringLength "${persistPath}" == 0) && ("${persistPath}" != null))
      "${persistPath}/etc/NetworkManager/system-connections";
  };
}
