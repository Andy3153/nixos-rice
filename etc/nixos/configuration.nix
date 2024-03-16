## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS configuration by Andy3153
## created   29/08/23 ~ 19:09:38
## rewrote   15/03/24 ~ 00:30:42
##

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "catfish"; # Define your hostname.

  # {{{ Boot
  boot =
  {
    consoleLogLevel = 0;
    kernelPackages =  pkgs.linuxPackages_zen;

    # {{{ Extra module packages
    extraModulePackages = with config.boot.kernelPackages;
    [
      nvidia_x11
    ];
    # }}}

    # {{{ Kernel parameters
    kernelParams =
    [
      "quiet"                  # Quiet boot
      "udev.log_level=0"       # [ ... ]
    ];
    # }}}

    # {{{ Supported filesystems
    supportedFilesystems =
    [
      "btrfs"
    ];
    # }}}

    # {{{ Initial ramdisk
    initrd =
    {
      verbose = false;

      systemd =
      {
        enable = true;
      };

      supportedFilesystems =
      [
        "btrfs"
      ];
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
        enable = true;
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

    # {{{ Plymouth
    plymouth =
    {
      enable =true;
    };
    # }}}
  };
  # }}}

  # {{{ Environment
  environment =
  {
    localBinInPath = true;

    # {{{ System packages
    systemPackages = with pkgs;
    [
      home-manager          # NixOS-Components

      neovim                # Text-Editors
      hunspell              # for-nvim for-libreoffice
      hunspellDicts.en_US   # for-nvim for-libreoffice

      efibootmgr            # EFI
      doas-sudo-shim        # Other-CLI doas
      git                   # Other-CLI Programming
      file                  # Other-CLI
      killall               # Other-CLI
      fastfetch             # Other-CLI fetch-system-info
      sshfs                 # for-ssh fs-support
      wget                  # download
      curl                  # download
      rsync                 # cp
      lsd                   # ls for-zsh
      ranger                # file-manager for-zsh for-nvim
      tmux                  # terminal-multiplexer
      htop                  # task-manager
      btop                  # task-manager
      nvtop                 # task-manager
      kitty.terminfo        # terminfo

      brightnessctl         # Other-CLI brightness hyprland-rice

      parted                # Partition-Manager

      wl-clipboard          # hyprland-rice for-zsh for-nvim clipboard

    ];
    # }}}

    # {{{ Shells
    shells =
    [
      pkgs.dash
      pkgs.zsh
    ];
    # }}}

    # {{{ Variables
    variables =
    {
      EDITOR =      "nvim";
      VISUAL =      "$EDITOR";
      SUDO_EDITOR = "$EDITOR";
      GIT_EDITOR =  "$EDITOR";
    };
    # }}}
  };
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
      (nerdfonts.override{fonts = [ "Iosevka" ]; })
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
    ];
    # }}}

    # {{{ Fontconfig
    fontconfig =
    {
        defaultFonts =
        {
            monospace = [ "Iosevka" ];
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
    enableAllFirmware = true;

    # {{{ Bluetooth
    bluetooth =
    {
        enable =      true;
        powerOnBoot = false;
    };
    # }}}

    # {{{ Intel CPU
    cpu.intel =
    {
        updateMicrocode = true;
    };
    # }}}

    # {{{ Nvidia
    /*nvidia =
    {
      modesetting.enable = true;
      prime =
      {
        intelBusId =  "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        offload =
        {
          enable =           true;
          enableOffloadCmd = true;
        };
      };
    };*/
    # }}}

    # {{{ OpenGL
    opengl =
    {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # }}}

    #xone.enable =    true;
    xpadneo.enable = true;
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
    stevenblack.enable = true;

    # {{{ NetworkManager
    networkmanager =
    {
        enable = true;
    };
    # }}}
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

      # {{{ Enable Hyprland Cachix
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
    dconf.enable    = true;
    hyprland.enable = true; # hyprland-rice wm
    htop.enable     = true; # Other-CLI task-manager

    # {{{ ReGreet
    regreet =
    {
      enable = true;
    };
    # }}}

    # {{{ Neovim
    neovim =
    {
      enable =        true;
      defaultEditor = true;
      vimAlias=       true;
    };
    # }}}

    # {{{ ZSH
    zsh =
    {
      enable =               true;
      enableBashCompletion = true;
    };
    # }}}
  };
  # }}}

  # {{{ Security
  security =
  {
    rtkit.enable = true; # pipewire wants it
    sudo.enable =  false;

    # {{{ Doas
    doas =
    {
      enable =      true;
      extraConfig = "permit persist setenv { WAYLAND_DISPLAY XAUTHORITY LANG LC_ALL } andy3153";
    };
    # }}}

    # {{{ Polkit
    polkit =
    {
      enable =true;
    };
    # }}}
  };
  # }}}

  # {{{ Services
  services =
  {
    flatpak.enable = true;

    # {{{ greetd
    greetd =
    {
      enable =  true;
      restart = true;
      settings = rec
      {
        initial_session =
        {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "andy3153";
        };

        default_session =
        {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        };
      };
    };
    # }}}

    # {{{ Hardware
    hardware =
    {
      openrgb.enable = true;
    };
    # }}}

    # {{{ OpenSSH
    openssh =
    {
      enable =       true;
      openFirewall = true;

      settings =
      {
        X11Forwarding =   true;
        PermitRootLogin = "yes";
      };
    };
    # }}}

    # {{{ Printing
    printing =
    {
      enable =          true;
      startWhenNeeded = true;
      webInterface =    false;

      drivers = with pkgs; [ brlaser ];
    };
    # }}}

    # {{{ PipeWire
    pipewire =
    {
      enable =            true;
      alsa.enable =       true;
      alsa.support32Bit = true;
      pulse.enable =      true;
    };
    # }}}

    # {{{ X Server
    xserver =
    {
      enable =       false;
      videoDrivers =
      [
        "modesetting"
        "intel"
        "nvidia"
        "fbdev"
      ];

      ## {{{ Display manager
      #displayManager =
      #{
      #  defaultSession = "hyprland";
      #
      #  # {{{ SDDM
      #  sddm =
      #  {
      #    enable =      true;
      #    autoNumlock = true;
      #    theme =       "breeze";
      #    settings =
      #    {
      #      Autologin =
      #      {
      #        User = "andy3153";
      #      };
      #    };
      #  };
      #  # }}}
      #};
      ## }}}
    };
    # }}}
  };
  # }}}

  ## {{{ Sound
  #sound =
  #{
  #  enable = true;
  #};
  ## }}}

  # {{{ System
  system =
  {
    stateVersion =            "23.05"; #"23.11";

    # {{{ Activation scripts
    #activationScripts =
    #{
    #  setup.text =
    #  ''
    #  # Check if it's the first time the script ran
    #  if [ -e /etc/nixos/.setup-done ]
    #  then exit
    #  else
    #    # Variables
    #    ghlink="https://github.com/Andy3153"
    #    git="${pkgs.git}/bin/git"
    #    su="${pkgs.su}/bin/su"
    #    nix_channel="${pkgs.nix}/bin/nix-channel"
    #    nix_shell="${pkgs.nix}/bin/nix-shell"
    #
    #    # Create folder structure
    #    mkdir -p /home/andy3153/src
    #    cd /home/andy3153/src
    #
    #    mkdir -p hyprland/hyprland-rice
    #    mkdir -p nixos/nixos-rice
    #    mkdir -p nvim/andy3153-init.lua
    #    mkdir -p sh/andy3153-zshrc
    #
    #    # Clone Git repos
    #    $git clone $ghlink/hyprland-rice hyprland/hyprland-rice
    #    $git clone $ghlink/nixos-rice nixos/nixos-rice
    #    $git clone $ghlink/andy3153-init.lua nvim/andy3153-init.lua
    #    $git clone $ghlink/andy3153-zshrc sh/andy3153-zshrc
    #
    #    # Clone zsh config deps
    #    mkdir -p sh/andy3153-zshrc/plugins
    #    mkdir -p sh/andy3153-zshrc/programs
    #
    #    $git clone https://github.com/zdharma-continuum/fast-syntax-highlighting sh/andy3153-zshrc/plugins/fast-syntax-highlighting
    #    $git clone https://github.com/zsh-users/zsh-autosuggestions sh/andy3153-zshrc/plugins/zsh-autosuggestions
    #    $git clone https://github.com/jeffreytse/zsh-vi-mode sh/andy3153-zshrc/plugins/zsh-vi-mode
    #    $git clone https://github.com/bake/ddate.sh sh/andy3153-zshrc/progs/ddate.sh
    #
    #
    #    # Link NixOS configs in their place
    #    rm -r /etc/nixos
    #    ln -s /home/andy3153/src/nixos/nixos-rice/etc/nixos /etc/
    #
    #    # Link home-manager configs in their place
    #    rm -r /home/andy3153/.config/home-manager
    #    ln -s /home/andy3153/src/nixos/nixos-rice/home/andy3153/.config/home-manager/ ~andy3153/.config/
    #
    #    # Install Home Manager for andy3153
    #    #$su andy3153 --shell ${pkgs.runtimeShell} --command "\
    #    #  source /etc/profile
    #    #  $nix_channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager && \
    #    #  $nix_channel --update && \
    #    #  $nix_shell \<home-manager\> -A install \
    #    #"
    #
    #    # Make sure andy3153 owns his files
    #    chown -R andy3153:andy3153 /home/andy3153
    #
    #    # Ensure it's the last time the script runs
    #    touch /etc/nixos/.setup-done
    #  fi
    #  '';
    #};
    # }}}
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
    #defaultUserShell =    pkgs.dash;
    enforceIdUniqueness = false;

    # {{{ Groups
    groups =
    {
      andy3153 =
      {
        gid = 3153;
        members = [ "andy3153" ];
      };
    };
    # }}}

    # {{{ Users
    users =
    {
      andy3153 =
      {
        description =     "Andy3153";
        initialPassword = "sdfsdf";
        isNormalUser =    true;
        createHome =      true;
        home =            "/home/andy3153";
        group =           "andy3153";
        extraGroups =     [ "wheel" ];
        shell =           pkgs.zsh;
        uid =             3153;
      };
    };
    # }}}
  };
  # }}}

  # {{{ XDG
  xdg =
  {
    portal =
    {
      enable = true;

      extraPortals = with pkgs;
      [
        xdg-desktop-portal-gtk
      ];

      config =
      {
        common =
        {
          default = "*";
        };
      };
    };
  };
  # }}}
}
