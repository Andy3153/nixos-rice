## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home Manager configuration by Andy3153
## created   03/09/23 ~ 16:57:11
##

{ config, pkgs, ... }:

{
  # {{{ Home
  home =
  {
    username = "andy3153";
    homeDirectory = "/home/andy3153";

    # {{{ Packages
    packages = with pkgs;
    [
      #zsh            # Shells
      #git            # Programming
      btop           # Other-CLI
      kitty          # hyprland-rice
      pulsemixer     # Sound Sound-Manager
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];
    # }}}

    # {{{ File
    file =
    {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };
    # }}}

    # {{{ XDG
    xdg =
    {
      enable = true;

    };
    # }}}

    stateVersion = "23.05";
  };
  # }}}

  # {{{ Programs
  programs =
  {
    home-manager.enable = true;

    # {{{ Git
    git =
    {
      enable =    true;
      userEmail = "andy3153@protonmail.com";
      userName =  "Andy3153";

      ignores =
      [
        "**/*.bak"
        "**/*.old"
        "**/.directory"
        "**/*.kate-swp"
        "**/*.kdev4"
        "**/.idea"
        "**/*.aux"
        "**/*.log"
        "**/*.out"
        "**/*.synctex.gz"
        "**/*.toc"
        "**/*.pyg"
        "**/*.latexrun.db"
        "**/*.latexrun.db.lock"
        "**/*.fdb_latexmk"
        "**/*.fls"
        "**/*.xdv"
      ];
    };
    # }}}

    # {{{ MangoHud
    mangohud =
    {
      enable = true;

      # {{{ Default settings
      settings =
      {
        legacy_layout=false # Disable legacy layout
        position=top-left   # On-screen position
        round_corners=0     # Rounded corners

        # Background
        background_alpha=0.4
        background_color=020202

        # Font
        font_size=22
        font_size_text=24
        font_scale=0.7
        text_color=ffffff

        # Keybinds
        toggle_hud=Control_L+Alt_L+M
        toggle_logging=Shift_L+F2
        upload_log=Shift_L+F5

        output_folder=~/.cache/MangoHud/logs # Log folder

        # FPS Counter
        fps
        engine_color=eb5b5b
        wine_color=eb5b5b

        # CPU Stats
        cpu_stats
        cpu_temp
        cpu_color=2e97cb
        cpu_text=CPU

        # GPU Stats
        gpu_stats
        gpu_temp
        gpu_color=2e9762
        gpu_text=GPU

        # RAM/VRAM Usage
        ram
        ram_color=c26693
        swap
        vram

        battery             # Battery Percentage
        time                # Clock

        # Media PLayer
        media_player
        media_player_format={title};{artist};{album}

        frame_timing=0      # Frame timing
      };
      # }}}

      # {{{ Settings per application
      settingsPerApplication =
      {
        MangoHud.top-center=
        {
          position=top-center;   # On-screen position
        };
      };
      # }}}
    };
    # }}}

    # {{{ Zsh
    zsh =
    {
      enable = true;
      dotDir = ".config/zsh";
    };
    # }}}
  };
  # }}}
}
