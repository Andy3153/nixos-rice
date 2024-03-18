## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home-Manager flake by Andy3153
## created   15/03/24 ~ 17:46:48
##

{
  description = "Andy3153's Home Manager flake";

  # {{{ Inputs
  inputs =
  {
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Flatpak
    #nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0"; # I'll just use it globally
  };
  # }}}

  # {{{ Outputs
  outputs = { nixpkgs, home-manager, ... }: # nix-flatpak, ... }:
  # {{{ Variables
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  # }}}
  {
    homeConfigurations =
    {
      # {{{ andy3153 Home-Manager configuration
      andy3153 = home-manager.lib.homeManagerConfiguration
      {
        inherit pkgs;

        modules =
        [
          #nix-flatpak.homeManagerModules.nix-flatpak
          ./home.nix
        ];
      };
      # }}}
    };
  };
  # }}}
}
