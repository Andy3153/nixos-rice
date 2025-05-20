## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Custom NixOS modules bundle
##

{ config, lib, pkgs, pkgs-stable, pkgs-unstable, ... }:

let
  mainUser = config.custom.users.mainUser;
in
{
  imports =
  [
    ./boot
    ./extraPackages
    ./gui
    ./hardware
    ./networking
    ./nix
    ./programs
    ./security
    ./services
    ./systemd
    ./users
    ./virtualisation
    ./xdg
  ];

  environment.localBinInPath = true;
  time.timeZone = "Europe/Bucharest";

  custom =
  {
    # {{{ Extra packages
    extraPackages = lib.lists.flatten
    [
      # {{{ Default NixPkgs
      (with pkgs;
      [
        file                       # Other-CLI
        usbutils                   # Other-CLI
        killall                    # Other-CLI
        ripgrep                    # Other-CLI
        fastfetch                  # Other-CLI fetch-system-info
        lm_sensors                 # Other-CLI sensors
        sshfs                      # for-ssh fs-support
        wget                       # download
        curl                       # download
        rsync                      # cp
        ranger                     # file-manager for-zsh for-nvim
        tmux                       # terminal-multiplexer
        htop                       # task-manager
        btop                       # task-manager
        kitty.terminfo             # terminfo

        brightnessctl              # Other-CLI brightness hyprland-rice

        parted                     # Partition-Manager
        e2fsprogs                  # Filesystem-Support ext*
        btrfs-progs                # Filesystem-Support btrfs
        exfatprogs                 # Filesystem-Support exfat
        dosfstools                 # Filesystem-Support fat*
        mtools                     # Filesystem-Support fat*
        fatresize                  # Filesystem-Support fat*
        ntfs3g                     # Filesystem-Support ntfs

        inotify-tools              # for-scripts
        libnotify                  # for-scripts

        unzip                      # archives
        unrar                      # archives
        p7zip                      # archives

        traceroute                 # networking
        whois                      # networking
      ])
      # }}}

      # {{{ NixPkgs Unstable
      (with pkgs-unstable;
      [
      ])
      # }}}

      # {{{ NixPkgs Stable
      (with pkgs-stable;
      [
      ])
      # }}}
    ];
    # }}}

    # {{{ Unfree whitelist
    nix.unfreeWhitelist =
    [
      "unrar"
    ];
    # }}}
  };

  # {{{ I18n
  i18n =
  {
    defaultLocale = "en_US.UTF-8";

    # {{{ Supported locales
    supportedLocales =
    [
      "en_US.UTF-8/UTF-8"
      "ro_RO.UTF-8/UTF-8"
    ];
    # }}}

    # {{{ Extra locale settings
    extraLocaleSettings =
    {
        LC_CTYPE =          "ro_RO.UTF-8";
        LC_NUMERIC =        "ro_RO.UTF-8";
        LC_TIME =           "ro_RO.UTF-8";
        LC_COLLATE =        "ro_RO.UTF-8";
        LC_MONETARY =       "ro_RO.UTF-8";
        LC_PAPER =          "ro_RO.UTF-8";
        LC_NAME =           "ro_RO.UTF-8";
        LC_ADDRESS =        "ro_RO.UTF-8";
        LC_TELEPHONE =      "ro_RO.UTF-8";
        LC_MEASUREMENT =    "ro_RO.UTF-8";
        LC_IDENTIFICATION = "ro_RO.UTF-8";
    };
    # }}}
  };
  # }}}

  # {{{ Home-Manager
  home-manager =
  {
    useGlobalPkgs   = true;
    useUserPackages = true;

    users.${mainUser} =
    {
      home =
      {
        stateVersion  = config.system.stateVersion;

        username      = mainUser;
        homeDirectory = config.users.users.${mainUser}.home;
      };

      news.display = "notify";                # Show news
      programs.home-manager.enable = true;    # let HM manage itself
    };
  };
  # }}}

# {{{ Nix
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
# }}}
}
