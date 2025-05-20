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
    # {{{ NixPkgs
    # NixPkgs Unstable
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs 25.05
    nixpkgs_stable.url   = "github:nixos/nixpkgs/nixos-25.05";

    # NixPkgs where TiLP still existed
    nixpkgs_tilp.url     = "github:nixos/nixpkgs/0be46d0515c69cddaea4c4e01b62e2a318c379b4";

    # NixPkgs (my fork for when I'm working on something)
    #nixpkgs_andy3153.url = "github:Andy3153/nixpkgs/hunspell-ro_RO";
    #nixpkgs_andy3153.url = "git+file:////home/andy3153/src/nixos/nixpkgs/?ref=hunspell-ro_RO";
    # }}}

    # {{{ My Nix packages
    my-nixpkgs_unstable =
    {
      url = "github:Andy3153/my-nixpkgs";
      #url = "git+file:///home/andy3153/src/nixos/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    my-nixpkgs_stable =
    {
      url = "github:Andy3153/my-nixpkgs";
      #url = "git+file:///home/andy3153/src/nixos/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #nixos-hardware.url = "github:Andy3153/nixos-hardware/asus-fx506hm_nvidia-open";
    #nixos-hardware.url = "git+file:///home/andy3153/src/nixos/nixos-hardware/?ref=asus-fx506hm_nvidia-open";
    # }}}

    # {{{ Lanzaboote
    lanzaboote_unstable =
    {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    lanzaboote_stable =
    {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ programs.sqlite for Nix Flakes
    flake-programs-sqlite_unstable =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    flake-programs-sqlite_stable =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ in-nix (add envvar when in `nix shell`)
    in-nix_unstable =
    {
      url = "github:viperML/in-nix";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    in-nix_stable =
    {
      url = "github:viperML/in-nix";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    # }}}

    # {{{ Home-Manager
    home-manager_unstable =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    home-manager_stable =
    {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ Jovian NixOS (Steam Deck UI)
    jovian_unstable =
    {
      #url = "github:Jovian-Experiments/Jovian-NixOS";
      url = "github:Andy3153/Jovian-NixOS/development_with_guard-overlay";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    jovian_stable =
    {
      #url = "github:Jovian-Experiments/Jovian-NixOS";
      url = "github:Andy3153/Jovian-NixOS/development_with_guard-overlay";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}

    # {{{ Disko
    disko_unstable =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    disko_stable =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };
    # }}}
  };
  # }}}

  # {{{ Outputs
  outputs = inputs@
  # {{{ Inputs
  {
    self,

    nixpkgs_unstable,
    nixpkgs_stable,
    nixpkgs_tilp,
    #nixpkgs_andy3153,

    my-nixpkgs_unstable,
    my-nixpkgs_stable,

    nixos-hardware,

    lanzaboote_unstable,
    lanzaboote_stable,

    flake-programs-sqlite_unstable,
    flake-programs-sqlite_stable,

    in-nix_unstable,
    in-nix_stable,

    nix-flatpak,

    home-manager_unstable,
    home-manager_stable,

    jovian_unstable,
    jovian_stable,

    disko_unstable,
    disko_stable,

    ...
  }: rec
  # }}}
  {
    # {{{ NixOS configurations
    nixosConfigurations =
    {
      # {{{ sparkle | ASUS TUF F15 FX506HM
      sparkle = nixpkgs_unstable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "sparkle"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
                pkgs-tilp     = import nixpkgs_tilp     { config = config.nixpkgs.config; };
                my-pkgs       = my-nixpkgs_unstable.packages.x86_64-linux;
              };
            }
          )
          # }}}

          nixos-hardware.nixosModules.asus-fx506hm
          lanzaboote_unstable.nixosModules.lanzaboote
          flake-programs-sqlite_unstable.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager_unstable.nixosModules.home-manager
          jovian_unstable.nixosModules.jovian

          ./hosts/sparkle
        ];
      };
      # }}}

      # {{{ ember | Raspberry Pi 4
      ember = nixpkgs_stable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "ember"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                boot.lanzaboote            = dummyOpt;
                jovian                     = dummyOpt;
                services.flatpak.overrides = dummyOpt;
                services.flatpak.packages  = dummyOpt;
                services.flatpak.update    = dummyOpt;
              };
            }
          )
          # }}}

          "${nixpkgs_stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          flake-programs-sqlite_stable.nixosModules.programs-sqlite
          home-manager_stable.nixosModules.home-manager

          ./hosts/ember
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

      # {{{ helix | Lenovo Ideapad 320
      helix = nixpkgs_stable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "helix"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                jovian                     = dummyOpt;
                services.flatpak.overrides = dummyOpt;
                services.flatpak.packages  = dummyOpt;
                services.flatpak.update    = dummyOpt;
              };
            }
          )
          # }}}

          lanzaboote_stable.nixosModules.lanzaboote
          flake-programs-sqlite_stable.nixosModules.programs-sqlite
          home-manager_stable.nixosModules.home-manager
          disko_stable.nixosModules.disko

          ./hosts/helix
        ];
      };
      # }}}

      # {{{ livecd | Live CD
      livecd = nixpkgs_unstable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        system      = "x86_64-linux";

        modules =
        [
          { networking.hostName = "nixos-live"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
                my-pkgs       = my-nixpkgs_unstable.packages.x86_64-linux;
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                boot.lanzaboote = dummyOpt;
                jovian          = dummyOpt;
              };
            }
          )
          # }}}

          "${nixpkgs_unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          flake-programs-sqlite_unstable.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager_unstable.nixosModules.home-manager

          ./hosts/livecd
        ];
      };
      # }}}
    };
    # }}}

    # {{{ NixOS modules
    nixosModules = rec
    {
      default    = nixos-rice;
      nixos-rice = ./modules;
    };
    # }}}

    # {{{ Images
    images =
    {
      ember = nixosConfigurations.ember-image.config.system.build.sdImage;
    };
    # }}}

    # {{{ Templates
    templates = rec
    {
      default = devenv-empty;

      # {{{ Development environments
      # {{{ Empty
      devenv-empty =
      {
        path = ./templates/devenv/empty;
        description = "Empty development environment";
      };
      # }}}

      # {{{ Python
      devenv-python =
      {
        path = ./templates/devenv/python;
        description = "Python development environment";
      };
      devenv-py = devenv-python;
      # }}}
      # }}}
    };
    # }}}
  };
  # }}}
}
