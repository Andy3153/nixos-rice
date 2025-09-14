## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Neovim config
##

{ config, lib, pkgs, pkgs-unstable, ... }:

let
  cfg                 = config.custom.programs.neovim;
  cfgGui              = config.custom.gui;

  mainUser            = config.custom.users.mainUser;
  HM                  = config.home-manager.users.${mainUser};
  mkOutOfStoreSymlink = HM.lib.file.mkOutOfStoreSymlink;

  homeDir             = HM.home.homeDirectory;
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
    custom.extraPackages = lib.lists.flatten
    [
      (with pkgs;
      [
        nvimpager
      ])

      (if cfg.enableCustomConfigs then with pkgs;
      [
        hunspell
        hunspellDicts.en_US
        hunspellDicts.ro_RO

        ripgrep
        wget

        python3
        gcc
        cargo
        gnumake
        yarn
        go

        tree-sitter

        # {{{ LSPs
        # Package                           # Language       # Name in Mason
        arduino-language-server             # arduino        # arduino_language_server
        clang-tools                         # c/c++          # clangd
        cmake-language-server               # cmake          # cmake
        docker-compose-language-service     # docker compose # docker_compose_language_service
        docker-language-server              # docker         # docker_language_server
        dockerfile-language-server          # dockerfile     # dockerls
        #missing                            # html           # html
        hyprls                              # hyprlang       # hyprls
        jdt-language-server                 # java           # jdtls
        lua-language-server                 # lua            # lua_ls
        marksman                            # markdown       # marksman
        nginx-language-server               # nginx          # nginx_language_server
        nil                                 # nix            # nil_ls
        nodePackages.bash-language-server   # bash/sh        # bashls
        nodePackages.vim-language-server    # vimscript      # vimls
        python311Packages.python-lsp-server # python         # pylsp
        taplo                               # toml           # taplo
        texlab                              # tex            # texlab
        vscode-css-languageserver           # css            # cssls
        yaml-language-server                # yaml           # yamlls
        # }}}
      ] else [])

      (if cfgGui.enable then with pkgs;
      [
        wl-clipboard
        neovide
      ] else [])
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
  home-manager.users.${mainUser} =
  {
    # {{{ Config files
    xdg.configFile = lib.mkIf cfg.enableCustomConfigs
    {
      "nvim".source = mkOutOfStoreSymlink "${homeDir}/src/nvim/andy3153-init.lua";
    };
    # }}}

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
