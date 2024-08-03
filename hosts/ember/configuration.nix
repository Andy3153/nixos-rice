## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `ember`
##
## Raspberry Pi 4
##

{ ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  users.users =
  {
    root.initialPassword = "sdfsdf";
    sdfsdf =
    {
      initialPassword = "sdfsdf";
      isNormalUser    = true;
    };
  };
}
