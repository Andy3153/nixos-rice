## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS flake by Andy3153
## created   02/12/23 ~ 15:17:52
## rewrote   15/03/24 ~ 16:56:09
##

{
  description = "Andy3153's Nix flake";

  # {{{ Inputs
  inputs =
  {
    # {{{ NixPkgs
    # NixPkgs Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs 24.05
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # NixPkgs for TiLP
    nixpkgs-tilp.url = "github:nixos/nixpkgs/0be46d0515c69cddaea4c4e01b62e2a318c379b4";

    # NixPkgs (my fork for when I'm working on something)
    #nixpkgs-andy3153.url = "github:Andy3153/nixpkgs/hunspell-ro_RO";
    #nixpkgs-andy3153.url = "git+file:////home/andy3153/src/nixos/nixpkgs/?ref=hunspell-ro_RO";
    # }}}

    # {{{ My Nix packages
    my-nixpkgs =
    {
      url = "github:Andy3153/my-nixpkgs";
      #url = "git+file:///home/andy3153/src/nixos/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #nixos-hardware.url = "github:Andy3153/nixos-hardware/asus-fx506hm_nvidia-open";
    #nixos-hardware.url = "git+file:///home/andy3153/src/nixos/nixos-hardware/?ref=asus-fx506hm_nvidia-open";
    # }}}

    # {{{ programs.sqlite for Nix Flakes
    flake-programs-sqlite =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    # }}}

    # {{{ Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable =
    {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # }}}
  };
  # }}}

  # {{{ Outputs
  outputs = inputs@
  # {{{ Inputs
  {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-tilp,
    #nixpkgs-andy3153,
    my-nixpkgs,
    nixos-hardware,
    flake-programs-sqlite,
    nix-flatpak,
    home-manager,
    home-manager-stable,
    ...
  }: rec
  # }}}
  {
    # {{{ NixOS configurations
    nixosConfigurations =
    {
      # {{{ sparkle | ASUS TUF F15 FX506HM
      sparkle = nixpkgs.lib.nixosSystem
      {
        modules =
        [
          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
                pkgs-tilp     = import nixpkgs-tilp   { config = config.nixpkgs.config; };
                my-pkgs       = my-nixpkgs.packages.x86_64-linux;
              };
            }
          )
          # }}}

          {
            networking.hostName = "sparkle";
            nixpkgs.hostPlatform.system = "x86_64-linux";
          }

          nixos-hardware.nixosModules.asus-fx506hm
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager

          ./hosts/sparkle/configuration.nix
        ];
      };
      # }}}

      # {{{ ember | Raspberry Pi 4
      ember = nixpkgs-stable.lib.nixosSystem
      {
        modules =
        [
          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          {
            networking.hostName           = "ember";
            nixpkgs =
            {
              config.allowUnsupportedSystem = true;
              hostPlatform.system           = "aarch64-linux";
            };
          }

          nixos-hardware.nixosModules.raspberry-pi-4
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager-stable.nixosModules.home-manager

          ./hosts/ember/configuration.nix
        ];
      };

      # {{{ Configuration for `ember` host when made into an SD card image
      ember-image = self.nixosConfigurations.ember.extendModules
      {
        modules = [ { disabledModules =
        [
          # These apply to the already-installed system and its custom
          # partitioning, we need to disable this for the image creation
          ./hosts/ember/hardware-configuration.nix
        ]; } ];
      };
      # }}}
      # }}}
    };
    # }}}

    # {{{ Images
    images =
    {
      ember = nixosConfigurations.ember-image.config.system.build.sdImage;
    };
    # }}}
  };
  # }}}
}
