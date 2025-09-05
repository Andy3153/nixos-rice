## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Nix bundle
##

{ lib, ... }:

{
  imports =
  [
    ./insecureWhitelist.nix
    ./package.nix
    ./unfreeWhitelist.nix
  ];

  nix =
  {
    channel.enable = false;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    # {{{ Settings
    settings =
    {
      auto-optimise-store = true;

      # {{{ Experimental features
      experimental-features =
      [
        "flakes"
        "nix-command"
      ];
      # }}}

      # {{{ Substituters
      substituters =
      [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys =
      [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # }}}
    };
    # }}}
  };
}
