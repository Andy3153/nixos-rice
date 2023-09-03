## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS configuration by Andy3153
## created   29/08/23 ~ 19:09:38
##

{ config, pkgs, ... }:

{
  imports =
  [
    /hardware-configuration.nix
    <home-manager/nixos>
  ];

  # {{{ Boot
  boot =
  {
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams =
    [
      "quiet"
      "udev.log_level=0"
    ];

    supportedFilesystems =
    [
      "btrfs"
    ];

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
        "vm.swappiness" = 30;
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

      efi =
      {
        canTouchEfiVariables = true;
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

    # {{{ Default packages
    defaultPackages = with pkgs;
    [
      neovim         # Text-Editors LaTeX

      nvimpager      # Other-CLI pager

      git            # Programming

      zsh            # Shells

      sshfs          # Other-CLI
      wget           # Other-CLI
      curl           # Other-CLI
      clolcat        # Other-CLI
      #rsync          # Other-CLI
      #android-tools  # Other-CLI Android ADB Fastboot
      #fatsort        # Other-CLI
      #yt-dlp         # Other-CLI
      #tmux           # Other-CLI
      #
      #pavucontrol-qt # Sound Sound-Manager
      #pulsemixer     # Sound Sound-Manager
      #qpwgraph       # Sound Patchbay
      #easyeffects    # Sound PipeWire
      #
      #gparted        # Partition-manager
      #btrbk          # Btrfs
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

  # {{{ Filesystems
  boot.initrd.luks.devices."nixos-crypt".device = "/dev/disk/by-partlabel/nixos-crypt";

  fileSystems =
  {
    "/" =
    {
      device  = "/dev/disk/by-label/nixos";
      fsType  = "btrfs";
      options = [ "subvol=/root" ];
    };

    "/boot" =
    {
      device  = "/dev/disk/by-label/ESP";
      fsType  = "vfat";
      depends = [ "/" ];
    };

    "/.btrfs-root" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/" ];
    };

    "/home" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/home" ];
    };

    "/.swap" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/swap" ];
    };

    "/.snapshots" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/snapshots" ];
    };

    "/.snapshots.externalhdd" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/snapshots.externalhdd" ];
    };

    "/var/cache" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/var-cache" ];
    };

    "/var/log" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/var-log" ];
    };

    "/var/tmp" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/var-tmp" ];
    };

    "/var/lib/libvirt/images" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" ];
      options = [ "subvol=/vms" ];
    };

    "/home/andy3153/games" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" "/home" ];
      options = [ "subvol=/games" ];
    };

    "/home/andy3153/torrents" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      depends = [ "/" "/home" ];
      options = [ "subvol=/torrents" ];
    };
  };

  swapDevices = [ { device = "/.swap/swapfile"; } ];
  # }}}

  # {{{ Fonts
  fonts =
  {
    enableDefaultFonts = true;

    # {{{ Fonts
    fonts =
    [
        pkgs.iosevka
        pkgs.cantarell-fonts
    ];
    # }}}

    # {{{ Fontconfig
    fontconfig =
    {
        defaultFonts =
        {
            monospace = [ "Iosevka" ];
            sansSerif = [ "Cantarell "];
        };
    };
    # }}}
  };
  #}}}

  # {{{ Hardware
  hardware =
  {
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
    nvidia =
    {
        prime.offload =
        {
            enable = true;
        };
    };
    # }}}

    xone.enable =    true;
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
    hostName =           "nixos";
    stevenblack.enable = true;

    # {{{ NetworkManager
    networkmanager =
    {
        enable = true;
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
    # {{{ Hyprland
    hyprland =
    {
      enable =        true;
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
  };
  # }}}

  # {{{ Services
  services =
  {

    flatpak.enable = true;
    openssh.enable = true;

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
      enable = true;

      displayManager =
      {
        defaultSession = "hyprland";

        sddm =
        {
          enable =      true;
          autoNumlock = true;
          theme =       "breeze";
        };
      };
    };
    # }}}
  };
  # }}}

  # {{{ System
  system =
  {
    copySystemConfiguration = true;
    stateVersion =            "23.05";
  };
  # }}}

  # {{{ Systemd
  #systemd.ctrlAltDelUnit = null;
  # }}}

  # {{{ Time
  time.timeZone =                        "Europe/Bucharest";
  # }}}

  # {{{ Users
  users =
  {
    #defaultUserShell =    pkgs.dash;
    enforceIdUniqueness = false;

    # {{{ Users
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
        description =  "Andy3153";
        initialPassword = "sdfsdfsdf";
        isNormalUser = true;
        createHome =   true;
        home =         "/home/andy3153";
        group =        "andy3153";
        shell =        pkgs.zsh;
        uid =          3153;
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
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  # }}}
}

