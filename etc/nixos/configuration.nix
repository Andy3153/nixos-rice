## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS configuration by Andy3153
## created   29/08/23 ~ 19:09:38
##

{ config, pkgs, ... }:

{
  imports =
  [
    #(import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz}/nixos")
    ./hardware-configuration-vm.nix
    #./hardware-configuration-milog.nix
    #<home-manager/nixos>
  ];

  # {{{ Boot
  boot =
  {
    consoleLogLevel = 0;
    kernelPackages =  pkgs.linuxPackages_zen;

    extraModulePackages = with config.boot.kernelPackages;
    [
      nvidia_x11
    ];

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
      #home-manager   # NixOS-Components
      neovim         # Text-Editors LaTeX
      sshfs          # Other-CLI
      wget           # Other-CLI
      curl           # Other-CLI
      rsync          # Other-CLI
      tmux           # Other-CLI
      file           # Other-CLI
      htop           # Other-CLI
      git            # Programming
      parted         # Partition-Manager
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
    /*nvidia =
    {
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
    dconf.enable = true;

    # {{{ Hyprland
    hyprland =
    {
      enable =        true;
      nvidiaPatches = true;
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
      enable =       true;
      videoDrivers = [ "modesetting" "nvidia" ];

      # {{{ Display manager
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
      # }}}
    };
    # }}}
  };
  # }}}

  # {{{ System
  system =
  {
    stateVersion =            "23.05";

    # {{{ Activation scripts
    activationScripts =
    {
      setup.text =
      ''
      # Check if it's the first time the script ran
      if [ -e /etc/nixos/.setup-done ]
      then exit
      else
        # Variables
        ghlink="https://github.com/Andy3153"
        git="${pkgs.git}/bin/git"
        su="${pkgs.su}/bin/su"
        nix_channel="${pkgs.nix}/bin/nix-channel"
        nix_shell="${pkgs.nix}/bin/nix-shell"

        # Create folder structure
        mkdir -p /home/andy3153/src
        cd /home/andy3153/src

        mkdir -p hyprland/hyprland-rice
        mkdir -p nixos/nixos-rice
        mkdir -p nvim/andy3153-init.lua
        mkdir -p sh/andy3153-zshrc

        # Clone Git repos
        $git clone $ghlink/hyprland-rice hyprland/hyprland-rice
        $git clone $ghlink/nixos-rice nixos/nixos-rice
        $git clone $ghlink/andy3153-init.lua nvim/andy3153-init.lua
        $git clone $ghlink/andy3153-zshrc sh/andy3153-zshrc

        # Clone zsh config deps
        mkdir -p sh/andy3153-zshrc/plugins
        mkdir -p sh/andy3153-zshrc/programs

        $git clone https://github.com/zdharma-continuum/fast-syntax-highlighting sh/andy3153-zshrc/plugins/fast-syntax-highlighting
        $git clone https://github.com/zsh-users/zsh-autosuggestions sh/andy3153-zshrc/plugins/zsh-autosuggestions
        $git clone https://github.com/jeffreytse/zsh-vi-mode sh/andy3153-zshrc/plugins/zsh-vi-mode
        $git clone https://github.com/bake/ddate.sh sh/andy3153-zshrc/progs/ddate.sh


        # Link NixOS configs in their place
        rm -r /etc/nixos
        ln -s /home/andy3153/src/nixos/nixos-rice/etc/nixos /etc/

        # Link home-manager configs in their place
        rm -r /home/andy3153/.config/home-manager
        ln -s /home/andy3153/src/nixos/nixos-rice/home/andy3153/.config/home-manager/ ~andy3153/.config/

        # Install Home Manager for andy3153
        #$su andy3153 --shell ${pkgs.runtimeShell} --command "\
        #  source /etc/profile
        #  $nix_channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager && \
        #  $nix_channel --update && \
        #  $nix_shell \<home-manager\> -A install \
        #"

        # Make sure andy3153 owns his files
        chown -R andy3153:andy3153 /home/andy3153

        # Ensure it's the last time the script runs
        touch /etc/nixos/.setup-done
      fi
      '';
    };
    # }}}
  };
  # }}}

  # {{{ Systemd
  #systemd.ctrlAltDelUnit = null;
  /*systemd =
  {
    user =
    {
      services =
      {
        getDotfiles =
        {
          enable =           true;
          description =      "User service to clone dotfiles";
          restartIfChanged = false;
          script =
          ''

          '';
        };
      };
    };
  };*/
  # }}}

  # {{{ Time
  time.timeZone =                        "Europe/Bucharest";
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
        initialPassword = "sdfsdfsdf";
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
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  # }}}
}
