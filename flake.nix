## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS flake by Andy3153
## created   02/12/23 ~ 15:17:52
## rewrote   15/03/24 ~ 16:56:09
##

{
  description = "Andy3153's NixOS flake";

  # {{{ Inputs
  inputs =
  {
    # NixPkgs Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs (my fork for when I'm working on something)
    nixpkgs-andy3153.url = "github:Andy3153/nixpkgs/hunspell-ro_RO";
    #nixpkgs-andy3153.url = "git+file:////home/andy3153/src/nixos/nixpkgs/?ref=hunspell-ro_RO";

    # Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";

    # programs.sqlite for Nix Flakes
    flake-programs-sqlite =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  # }}}

  # {{{ Outputs
  outputs = { self, nixpkgs, nixpkgs-andy3153, home-manager, nix-flatpak, flake-programs-sqlite, nixos-hardware, ... }@inputs:
  # {{{ Variables
  let
    system = "x86_64-linux";

    # NixPkgs Unstable
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
    };

    # NixPkgs (my fork for when I'm working on something)
    pkgs-andy3153 = import nixpkgs-andy3153
    {
      inherit system;
      config.allowUnfree = true;
    };
  in
  # }}}
  {
    nixosConfigurations =
    {
      # {{{ sparkle
      sparkle = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs system pkgs pkgs-andy3153; };

        modules =
        [
          { networking.hostName = "sparkle"; }

          nixos-hardware.nixosModules.asus-fx506hm
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak

          ./hosts/sparkle/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager =
            {
              useGlobalPkgs   = true;
              useUserPackages = true;
              users.andy3153  = import ./home.nix;
            };
          }
        ];
      };
      # }}}
    };
  };
  # }}}
}
