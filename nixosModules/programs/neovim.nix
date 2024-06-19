## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Neovim config
##

{ config, lib, pkgs, pkgs-stable, ... }:

let
  cfg    = config.custom.programs.neovim;
  cfgGui = config.custom.gui;
in
{
  options.custom.programs.neovim =
  {
    enable              = lib.mkEnableOption "enables Neovim";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Packages
    environment.systemPackages = lib.mkMerge
    [
      (with pkgs;
      [
        nvimpager
      ])

      (lib.mkIf cfg.enableCustomConfigs (with pkgs;
      [
        hunspell
        hunspellDicts.en_US
        hunspellDicts.ro_RO

        python3
        gcc

        arduino-language-server
        nodePackages.bash-language-server
        clang-tools
        cmake-language-server
        dockerfile-language-server-nodejs
        lua-language-server
        marksman
        nil
        python311Packages.python-lsp-server
        texlab
        nodePackages.vim-language-server
      ]))

      (lib.mkIf cfg.enableCustomConfigs (with pkgs-stable;
      [
      ]))

      (lib.mkIf cfgGui.enable (with pkgs;
      [
        wl-clipboard
        neovide
      ]))
    ];
    # }}}

    # {{{ Neovim program
    programs.neovim =
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

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    home =
    {
      # {{{ Config files
      file = lib.mkIf cfg.enableCustomConfigs
      {
        ".config/nvim".source    = /home/andy3153/src/nvim/andy3153-init.lua;
        ".config/nvim".recursive = true; # because package managers create some files in here
      };
      # }}}

      # {{{ Home packages
      #packages = lib.mkMerge
      #[
      #  (lib.mkIf cfgGui.enable (with pkgs;
      #  [
      #    neovide
      #  ]))
      #
      #  (lib.mkIf cfg.enableCustomConfigs lib.mkMerge
      #  [
      #    (with pkgs;
      #    [
      #      arduino-language-server
      #      #nodePackages.bash-language-server
      #      clang-tools
      #      cmake-language-server
      #      dockerfile-language-server-nodejs
      #      lua-language-server
      #      marksman
      #      nil
      #      python311Packages.python-lsp-server
      #      texlab
      #      nodePackages.vim-language-server
      #    ])
      #
      #    (with pkgs-stable;
      #    [
      #      nodePackages.bash-language-server
      #    ])
      #  ])
      #];
      # }}}
    };

    # {{{ Neovim program
    programs.neovim =
    {
      enable        = true;
      defaultEditor = true;

      viAlias       = true;
      vimAlias      = true;
      vimdiffAlias  = true;

      withNodeJs    = true;
      withPython3   = true;
      withRuby      = true;
    };
    # }}}
  };
  # }}}
  };
}
