## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `ember`
##
## Raspberry Pi 4
##

{ ... }:

{
  #networking.networkmanager.enable = true;
  #boot.initrd.network.enable = true;
  #boot.initrd.network.ssh.enable = true;

  nix.settings =
  {
    substituters =
    [
      "https://hydra.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];

    trusted-public-keys =
    [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  services.openssh =
  {
    enable = true;

    settings =
    {
      PasswordAuthentication = true;
    };
  };

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
