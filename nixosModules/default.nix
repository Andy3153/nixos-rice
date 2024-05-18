## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Default NixOS config
##

{ config, lib, pkgs, ... }:

{
  # {{{ Boot
  boot =
  {
    # {{{ Initial ramdisk
    initrd =
    {
      systemd.enable = true;
    };
    # }}}

    # {{{ Kernel
    kernel =
    {
      sysctl =
      {
        "vm.swappiness" = 30;  # Swappiness
        "kernel.sysrq"  = 244; # Enable Magic SysRQ keys (REISUB sequence only (4+64+16+32+128))
      };
    };
    # }}}

    # {{{ Bootloader
    loader =
    {
      timeout = 0;

      systemd-boot =
      {
        editor = false;
      };

      grub =
      {
        efiSupport = false;
      };

      efi =
      {
        canTouchEfiVariables = true;
        efiSysMountPoint     = "/boot";
      };
    };
    # }}}
  }
  # }}}

  # {{{ Environment
  environment =
  {
    localBinInPath = true;

    # {{{ System packages
    systemPackages = with pkgs;
    [
      home-manager               # NixOS-Components

      nvimpager                  # for-nvim

      doas-sudo-shim             # for-doas

      git                        # Programming
      python3                    # Programming for-nvim
      gcc                        # Programming for-nvim

      file                       # Other-CLI
      killall                    # Other-CLI
      fastfetch                  # Other-CLI fetch-system-info
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
    ];
    # }}}
  }
  # }}}

  # {{{ Fonts
  fonts =
  {
    enableDefaultPackages = true;
    fontDir.enable        = true;

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
    cpu.amd.updateMicrocode   = true;
    cpu.intel.updateMicrocode = true;
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
        #LC_CTYPE =          "ro_RO.UTF-8";
        LC_NUMERIC =        "ro_RO.UTF-8";
        LC_TIME =           "ro_RO.UTF-8";
        #LC_COLLATE =        "ro_RO.UTF-8";
        LC_MONETARY =       "ro_RO.UTF-8";
        #LC_MESSAGES =       "ro_RO.UTF-8";
        LC_PAPER =          "ro_RO.UTF-8";
        LC_NAME =           "ro_RO.UTF-8";
        LC_ADDRESS =        "ro_RO.UTF-8";
        LC_TELEPHONE =      "ro_RO.UTF-8";
        LC_MEASUREMENT =    "ro_RO.UTF-8";
        #LC_IDENTIFICATION = "ro_RO.UTF-8";
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
    htop.enable     = true; # task-manager
    java.enable     = true; # Programming

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
    sudo.enable   = false;
    polkit.enable = true;

    # {{{ Doas
    doas =
    {
      enable      = true;
      extraConfig = "permit persist setenv { WAYLAND_DISPLAY XAUTHORITY LANG LC_ALL } andy3153";
    };
    # }}}
  };
  # }}}

  # {{{ Services
  services =
  {
    # {{{ OpenSSH
    openssh =
    {
      enable =       true;
      openFirewall = true;

      settings =
      {
        X11Forwarding   = true;
        PermitRootLogin = "yes";
      };
    };
    # }}}
  };
  # }}}

  # {{{ System
  system =
  {
    stateVersion = "23.05"; #"23.11";
  };
  # }}}

  # {{{ Systemd
  systemd.ctrlAltDelUnit = "";
  # }}}

  # {{{ Time
  time.timeZone = "Europe/Bucharest";
  # }}}

  # {{{ Users
  users =
  {
    enforceIdUniqueness = false;

    # {{{ Groups
    groups =
    {
      andy3153 =
      {
        gid     = 3153;
        members = [ "andy3153" ];
      };

      #bot =
      #{
      #  members = [ "bot" ];
      #};
    };
    # }}}

    # {{{ Users
    users =
    {
      andy3153 =
      {
        description     = "Andy3153";
        initialPassword = "sdfsdf";
        isNormalUser    = true;
        group           = "andy3153";
        shell           = pkgs.zsh;
        uid             = 3153;

        extraGroups =
        [
          "docker"
          "libvirtd"
          "wheel"
        ];
      };

      #bot =
      #{
      #  description     = "Bot";
      #  initialPassword = "sdfsdf";
      #  isNormalUser    = true;
      #  group           = "bot";
      #};
    };
    # }}}
  };
  # }}}

}
