## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Common settings that every host shares
##

{ config, lib, pkgs, pkgs-andy3153, ... }:

# {{{ Variables
let
  nixConfigFolderPath  = "/home/${config.custom.users.mainUser}/src/nixos/nixos-rice";
  nixConfigurationPath = "${nixConfigFolderPath}/hosts/sparkle/configuration.nix";
in
# }}}
{
  # {{{ Boot
  boot.initrd.systemd.enable = true;
  # }}}

  # {{{ Environment
  environment =
  {
    localBinInPath = true;

    # {{{ System packages
    systemPackages = lib.mkMerge
    [
      # {{{ NixPkgs Unstable
      (with pkgs;
      [
        home-manager               # NixOS-Components

        nvimpager                  # for-nvim
        hunspell                   # for-nvim for-libreoffice
        hunspellDicts.en_US        # for-nvim for-libreoffice

        efibootmgr                 # EFI
        doas-sudo-shim             # for-doas

        git                        # Programming

        (python3.withPackages(     # Programming for-nvim
        python-pkgs:
        [
          python-pkgs.requests     # for-waybar
        ])) # nix purists don't
            # kill me for doing
            # this pls

        gcc                        # Programming for-nvim

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
        lsd                        # ls for-zsh
        lolcat                     # for-zsh
        colordiff                  # for-zsh
        ranger                     # file-manager for-zsh for-nvim
        tmux                       # terminal-multiplexer
        htop                       # task-manager
        btop                       # task-manager
        nvtopPackages.full         # task-manager
        kitty.terminfo             # terminfo

        brightnessctl              # Other-CLI brightness hyprland-rice

        parted                     # Partition-Manager

        wl-clipboard               # hyprland-rice for-zsh for-nvim clipboard

        inotify-tools              # for-scripts
        libnotify                  # for-scripts

        unzip                      # archives
      ])
      # }}}

      # {{{ NixPkgs (my fork for when I'm working on something)
      (with pkgs-andy3153;
      [
        hunspellDicts.ro_RO
      ])
      # }}}
    ];
    # }}}
  };
  # }}}

  # {{{ Fonts
  fonts =
  {
    enableDefaultPackages = true;
    fontDir.enable        = true; # for flatpak

    # {{{ Fonts
    packages = with pkgs;
    [
      cantarell-fonts
      (nerdfonts.override{ fonts = [ "IosevkaTerm" "Iosevka" ]; })
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
    ];
    # }}}

    # {{{ Fontconfig
    fontconfig =
    {
      enable = true;

      defaultFonts =
      {
        monospace = [ "IosevkaTerm NF" ];
        serif     = [ "Cantarell" ];
        sansSerif = [ "Cantarell" ];
      };
    };
    # }}}
  };
  #}}}

  # {{{ Hardware
  hardware =
  {
    enableAllFirmware         = true;
  };
  # }}}

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

  # {{{ Networking
  networking =
  {
    networkmanager.enable = true;
  };
  # }}}

# {{{ Nix
  nix =
  {
    package = pkgs.nixFlakes;

    # {{{ Nix Path
    nixPath =
    [
      "nixos-config=${nixConfigurationPath}"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    # }}}

    # {{{ Settings
    settings =
    {
      # {{{ Experimental features
      experimental-features =
      [
        "nix-command"
        "flakes"
      ];
      # }}}
    };
    # }}}
  };
# }}}

  # {{{ Nix packages
  nixpkgs.config.allowUnfree = true;
  # }}}

  # {{{ Programs
  programs =
  {
    # {{{ Neovim
    neovim =                # Text-Editors
    {
      enable        = true;
      defaultEditor = true;

      viAlias       = true;
      vimAlias      = true;

      withNodeJs    = true;
      withPython3   = true;
      withRuby      = true;
    };
    # }}}

    # {{{ Nh
    nh =                # NixOS-Components
    {
      enable = true;
      flake  = "${nixConfigFolderPath}";
      clean =
      {
        enable    = true;
        dates     = "weekly";
        extraArgs = "--keep 2 --keep-since 2d";
      };
    };
    # }}}

    # {{{ Zsh
    zsh =
    {
      enable               = true;
      enableBashCompletion = true;
      shellInit = # use ZDOTDIR
      ''
        export ZDOTDIR="~/.config/zsh"
        if [ -e ~/.config/zsh/.zshenv ]
        then source ~/.config/zsh/.zshenv
        fi
      '';
    };
    # }}}
  };
  # }}}

  # {{{ Security
  security =
  {
    rtkit.enable = true; # pipewire wants it
    sudo.enable  = false;

    # {{{ Doas
    doas =
    {
      enable      = true;
      extraConfig = "permit persist setenv { WAYLAND_DISPLAY XAUTHORITY LANG LC_ALL } ${config.custom.users.mainUser}";
    };
    # }}}

    # {{{ Polkit
    polkit =
    {
      enable = true;
    };
    # }}}
  };
  # }}}

  # {{{ Services
  services =
  {
    xserver.enable = false;

    # {{{ OpenSSH
    openssh =
    {
      enable       = true;
      openFirewall = true;

      settings =
      {
        X11Forwarding   = true;
        PermitRootLogin = "prohibit-password";
      };
    };
    # }}}
  };
  # }}}

  # {{{ System
  system.stateVersion = "23.05";
  # }}}

  # {{{ Systemd
  systemd.ctrlAltDelUnit = "";
  # }}}

  # {{{ Time
  time.timeZone = "Europe/Bucharest";
  # }}}

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    home =
    {
      stateVersion  = config.system.stateVersion;

      username      = config.custom.users.mainUser;
      homeDirectory = "/home/${config.custom.users.mainUser}";
    };

    fonts.fontconfig.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
  # }}}
}
