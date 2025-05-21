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

        tree-sitter

        arduino-language-server             # arduino-language-server (arduino_language_server)
        nodePackages.bash-language-server   # bash-language-server (bashls)
        clang-tools                         # clangd
        cmake-language-server               # cmake-language-server (cmake)
        dockerfile-language-server-nodejs   # dockerfile-language-server (dockerls)
        #missing                            # html-lsp
        jdt-language-server                 # jdtls
        lua-language-server                 # lua-language-server (lua_ls)
        marksman                            # marksman
        nil                                 # nil_ls
        python311Packages.python-lsp-server # python-lsp-server (pylsp)
        texlab                              # texlab
        nodePackages.vim-language-server    # vim-language-server (vimls)
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
