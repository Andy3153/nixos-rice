## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Git config
##

{ config, lib, ... }:

let
  cfg      = config.custom.programs.git;
  mainUser = config.custom.users.mainUser;

  # {{{ Git extra config
  gitExtraConfig =
  {
    core =
    {
      autocrlf = "input";
      safecrlf = "true";
    };

    merge.tool              = "vimdiff";
    mergetool.prompt        = true;
    mergetool."vimdiff".cmd = "nvim -d $REMOTE $LOCAL";

    diff.tool               = "vimdiff";
    difftool.prompt         = false;

    user =
    {
      name  = cfg.userName;
      email = cfg.userEmail;
    };
  };
  # }}}
in
{
  options.custom.programs.git =
  {
    enable     = lib.mkEnableOption "enables Git";
    lfs.enable = lib.mkEnableOption "enables Git LFS";

    userName = lib.mkOption
    {
      type        = lib.types.nullOr lib.types.str;
      default     = lib.types.null;
      description = "default Git user name";
    };

    userEmail = lib.mkOption
    {
      type        = lib.types.nullOr lib.types.str;
      default     = lib.types.null;
      description = "default Git user email";
    };
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Git program
    programs.git =
    {
      enable     = true;
      config     = gitExtraConfig;
      lfs.enable = cfg.lfs.enable;
    };
    # }}}

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      # {{{ Git program
      programs.git =
      {
        enable     = true;
        settings   = gitExtraConfig;
        lfs.enable = cfg.lfs.enable;

        # {{{ Files to ignore
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
          "/.direnv/"
        ];
        # }}}
      };
      # }}}
    };
    # }}}
  };
}
