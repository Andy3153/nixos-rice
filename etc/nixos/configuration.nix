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
    consoleLogLevel = 0; # Quiet boot
    kernelPackages  = pkgs.linuxPackages_zen;

    # {{{ Kernel modules
    kernelModules =
    [
      "i2c-dev"
    ];
    # }}}

    # {{{ Extra module packages
    extraModulePackages = with config.boot.kernelPackages;
    [
      v4l2loopback
      nvidia_x11
    ];
    # }}}

    # {{{ Extra modprobe config
    extraModprobeConfig =
    ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    # }}}

    # {{{ Kernel parameters
    kernelParams =
    [
      "quiet"            # Quiet boot
      "udev.log_level=0" # [ ... ]
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

      #systemd =
      #{
      #  enable = true;
      #};

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
      enable = true;
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
      home-manager               # NixOS-Components

      nvimpager                  # for-nvim
      hunspell                   # for-nvim for-libreoffice
      hunspellDicts.en_US        # for-nvim for-libreoffice

      efibootmgr                 # EFI
      doas-sudo-shim             # for-doas

      git                        # Programming
      python3                    # Programming for-nvim
      python3Packages.requests   # for-waybar
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

    # {{{ Shells
    shells =
    [
      pkgs.dash
      pkgs.zsh
    ];
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
      (nerdfonts.override{fonts = [ "IosevkaTerm" "Iosevka" ]; })
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
    cpu.intel.updateMicrocode = true;

    # {{{ Bluetooth
    bluetooth =
    {
        enable      = true;
        powerOnBoot = false;
    };
    # }}}

    # {{{ Nvidia
    /*nvidia =
    {
      modesetting.enable = true;
      prime =
      {
        intelBusId  = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        offload =
        {
          enable           = true;
          enableOffloadCmd = true;
        };
      };
    };*/
    # }}}

    # {{{ OpenGL
    opengl =
    {
      enable          = true;
      driSupport      = true;
      driSupport32Bit = true;
    };
    # }}}

    # {{{ OpenTabletDriver
    opentabletdriver =
    {
      enable        = true;
      daemon.enable = true;
    };
    # }}}

    i2c.enable                = true;
    #sane.enable               = true;
    xone.enable               = true;
    xpadneo.enable            = true;
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
    gamemode.enable = true; # games
    hyprland.enable = true; # hyprland-rice wm
    htop.enable     = true; # task-manager
    java.enable     = true; # Programming

    # {{{ ReGreet
    regreet =
    {
      enable = true;
    };
    # }}}

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

  # {{{ Steam
  steam =
  {
    enable                       = true;

    #gamescopeSession.enable      = true;

    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall      = true;

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

  ## {{{ Qt
  #qt =
  #{
  #  enable        = true;
  #  platformTheme = "qt5ct";
  #
  #  # {{{ Qt style
  #  style = lightly;
  #  # }}}
  #};
  ## }}}

  # {{{ Security
  security =
  {
    rtkit.enable = true; # pipewire wants it
    sudo.enable  = false;

    # {{{ Doas
    doas =
    {
      enable      = true;
      extraConfig = "permit persist setenv { WAYLAND_DISPLAY XAUTHORITY LANG LC_ALL } andy3153";
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
    # {{{ Ananicy
    ananicy =
    {
      enable  = true;
      package = pkgs.ananicy-cpp;
    };
    # }}}

    # {{{ Btrbk
    btrbk.instances =
    {
      # {{{ Daily local backup
      ##
      ## Contains subvolumes that get backed up daily, and kept locally as snapshots
      ##

      daily-local =
      {
        onCalendar = "daily";
        settings =
        {
          timestamp_format      = "long";

          snapshot_preserve     = "5d";
          snapshot_preserve_min = "2d";

          volume."/.btrfs-root" =
          {
            snapshot_dir = "snapshots";
            subvolume."root".snapshot_create = "onchange";
            subvolume."nix".snapshot_create = "onchange";
            subvolume."home".snapshot_create = "onchange";
          };
        };
      };
      # }}}

      # {{{ Backup to external hard drive
      ##
      ## Contains subvolumes that get backed up to an external hard drive
      ##

      externalhdd =
      {
        onCalendar = "null";
        settings =
        {
          timestamp_format      = "long";

          snapshot_preserve_min = "latest";

          volume."/.btrfs-root" =
          {
            snapshot_dir = "snapshots.externalhdd";

            subvolume."root".snapshot_create = "onchange";
            subvolume."root".target = "/mnt/sparkle_snapshots/";

            subvolume."nix".snapshot_create = "onchange";
            subvolume."nix".target = "/mnt/sparkle_snapshots/";

            subvolume."home".snapshot_create = "onchange";
            subvolume."home".target = "/mnt/sparkle_snapshots/";
          };
        };
      };
      # }}}

      # {{{ Backup to external hard drive (full)
      ##
      ## Contains subvolumes that get backed up to an external hard drive
      ##

      externalhdd-full =
      {
        onCalendar = "null";
        settings =
        {
          timestamp_format      = "long";

          snapshot_preserve_min = "latest";

          volume."/.btrfs-root" =
          {
            snapshot_dir = "snapshots.externalhdd";

            subvolume."root".snapshot_create = "onchange";
            subvolume."root".target = "/mnt/sparkle_snapshots/";

            subvolume."nix".snapshot_create = "onchange";
            subvolume."nix".target = "/mnt/sparkle_snapshots/";

            subvolume."home".snapshot_create = "onchange";
            subvolume."home".target = "/mnt/sparkle_snapshots/";

            subvolume."games".snapshot_create = "onchange";
            subvolume."games".target = "/mnt/sparkle_snapshots/";

            subvolume."vms".snapshot_create = "onchange";
            subvolume."vms".target = "/mnt/sparkle_snapshots/";

            subvolume."torrents".snapshot_create = "onchange";
            subvolume."torrents".target = "/mnt/sparkle_snapshots/";

            subvolume.".beeshome".snapshot_create = "onchange";
            subvolume.".beeshome".target = "/mnt/sparkle_snapshots/";
          };
        };
      };
      # }}}

    };
    # }}}

    # {{{ Flatpak
    flatpak =
    {
      enable = true;

      # {{{ Packages
      packages =
      [
        "com.github.tchx84.Flatseal"         # Base-System
        "io.gitlab.librewolf-community"      # Browsers
        "com.brave.Browser"                  # Browsers
        "org.torproject.torbrowser-launcher" # Browsers Tor

        "com.discordapp.Discord"             # Social
        "io.github.trigg.discover_overlay"   # for-discord
        "org.ferdium.Ferdium"                # Social

        "com.spotify.Client"                 # Music-Players
      ];
      # }}}

      # {{{ Overrides
      overrides =
      {
        global =
        {
          Context =
          {
            filesystems =
            [
              "$HOME/.local/share/icons"
              "$HOME/.local/share/themes"
              "$HOME/.local/share/fonts"
            ];
          };

          Environment =
          {
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
          };
        };
      };
      # }}}
    };
    # }}}

    # {{{ greetd
    greetd =
    {
      enable  = true;
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
        X11Forwarding   = true;
        PermitRootLogin = "yes";
      };
    };
    # }}}

    # {{{ Printing
    printing =
    {
      enable          = true;
      startWhenNeeded = true;
      webInterface    = false;

      drivers = with pkgs; [ brlaser ];
    };
    # }}}

    # {{{ PipeWire
    pipewire =
    {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
    };
    # }}}

    # {{{ X Server
    xserver =
    {
      enable       = false;
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
      #    enable      = true;
      #    autoNumlock = true;
      #    theme       = "breeze";
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
    stateVersion = "23.05"; #"23.11";

    # {{{ Activation scripts
    activationScripts =
    {
      # {{{ Post-install script
#      postInstall.text =
#      ''
### vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
###
### NixOS post-install script
###
#
## Check if it's the first time the script ran
#if [ -e "/etc/nixos/.setup-done" ]
#then exit 1
#else
#
## {{{ Variables
## {{{ Basic
#user="andy3153"
#userHome="~$user"
#
#ghlink="https://github.com/Andy3153"
## }}}
#
## {{{ Programs
#ping="${pkgs.unixtools.ping}/bin/ping"
#git="${pkgs.git}/bin/git"
#su="${pkgs.su}/bin/su"
#nix="${pkgs.nix}/bin/nix"
## }}}
## }}}
#
#  # {{{ Check internet connection
#  if ! $ping -q -c1 1.1.1.1 &> /dev/null
#  then print "No internet!" ; exit 1
#  fi
#  # }}}
#
#  # {{{ Create the folder structure
#  mkdir -p "$userHome/src"
#  cd "$userHome/src"
#  mkdir -p "nixos/nixos-rice" "hyprland/hyprland-rice" "nvim/andy3153-init.lua" "sh/andy3153-zshrc"
#  # }}}
#
#  # {{{ Clone the Git repos
#  if [ -z "$(ls -A "nixos/nixos-rice")" ]
#  then $git clone "$ghlink/nixos-rice" "nixos/nixos-rice"
#  fi
#
#  if [ -z "$(ls -A "hyprland/hyprland-rice")" ]
#  then $git clone "$ghlink/hyprland-rice" "hyprland/hyprland-rice"
#  fi
#
#  if [ -z "$(ls -A "nvim/andy3153-init.lua")" ]
#  then $git clone "$ghlink/andy3153-init.lua" "nvim/andy3153-init.lua"
#  fi
#
#  if [ -z "$(ls -A "sh/andy3153-zshrc")" ]
#  then $git clone "$ghlink/andy3153-zshrc" "sh/andy3153-zshrc"
#  fi
#  # }}}
#
#  $su "$user" -c "$nix run home-manager/master -- init"            # Initialize HM for user
#
#  # {{{ Link NixOS configs in their place
#  rm -r "/etc/nixos"
#  ln -s "$userHome/src/nixos/nixos-rice/etc/nixos" "/etc/"
#
#  rm -r "$userHome/.config/home-manager"
#  ln -s "$userHome/src/nixos/nixos-rice/home/andy3153/.config/home-manager/" "$userHome/.config/"
#  # }}}
#
#  # {{{ Finishing steps
#  chown -R "$user":"$user" "$userHome"                             # Make sure user owns his files
#  $su "$user" -c "$nix run home-manager/master -- switch --impure" # Install HM for user
#  touch "/etc/nixos/.setup-done"                                   # Make sure it's the last time this script runs
#  # }}}
#
#fi
#      '';
      # }}}
    };
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

  # {{{ Virtualisation
  virtualisation =
  {
    # {{{ Docker
    docker =
    {
      enable           = true;
      enableNvidia     = true;
      enableOnBoot     = false;

      autoPrune.enable = true;
    };
    # }}}

    # {{{ Libvirtd
    libvirtd =
    {
      enable     = true;
      onBoot     = "ignore";
      onShutdown = "suspend";

      qemu =
      {
        runAsRoot    = false;
        swtpm.enable = true;
      };
    };
    # }}}

    waydroid.enable = true;
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
