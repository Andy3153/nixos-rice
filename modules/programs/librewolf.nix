## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Librewolf config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.adb;

  mainUser = config.custom.users.mainUser;
  userName = config.users.users.${mainUser}.description;
  hostName = config.networking.hostName;
in
{
  options.custom.programs.librewolf.enable = lib.mkEnableOption "enables Librewolf";
  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      programs.librewolf =
      {
        enable = true;

        # {{{ Language packs
        languagePacks =
        [
          "en-US"
          "ro"
        ];
        # }}}

        # {{{ Policies
        policies =
        {
          DisableFirefoxStudies       = true;
          DisableSetDesktopBackground = true;
          DisablePocket               = true;
          DisableTelemetry            = true;
        };
        # }}}

        # {{{ Default Profile
        profiles."Default Profile" =
        {
          # {{{ Search
          search = rec
          {
            default        = "brave-search";
            privateDefault = default;
            force          = true;

            # {{{ Search order
            order =
            [
              "brave-search"
              "startpage"
              "duckduckgo"
              "google"
              "yandex"

              "youtube"

              "wikipedia"
              "dexonline"

              "nixos-wiki"
              "nixos-search_packages"
              "nixos-search_options"
              "mynixos"
              "mynixos_options"
              "nix-user-repository"
              "nixpkgs-github-issues"

              "arch-linux-wiki"
              "arch-linux-packages"
              "arch-user-repository"

              "ctan"

              "steam-store"
              "protondb"

              "terraria-wiki"
              "calamity-mod-wiki"
              "stardew-valley-wiki"
              "earthbound-wiki"

              "linkedin"
            ];
            # }}}

            # {{{ Custom search engines
            ##
            ## `​` characters are used to bypass search engines with the same
            ## name as the builtin search engines
            ##
            engines =
            {
              # {{{ Brave Search
              brave-search =
              {
                name           = "Brave Search​";
                definedAliases = [ "@b" ];
                urls           = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
              };
              # }}}

              # {{{ Startpage
              startpage =
              {
                name           = "Startpage​";
                definedAliases = [ "@s" ];
                urls           =
                [{
                  template = "https://startpage.com/sp/search";
                  method   = "POST";

                  params =
                  [
                    {
                      name  = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }];
              };
              # }}}

              # {{{ DuckDuckGo
              duckduckgo =
              {
                name           = "DuckDuckGo​";
                definedAliases = [ "@d" ];
                urls           = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
              };
              # }}}

              # {{{ Google
              google =
              {
                name           = "Google​";
                definedAliases = [ "@g" ];
                urls           = [{ template = "https://www.google.com/search?q={searchTerms}"; }];
              };
              # }}}

              # {{{ Yandex
              yandex =
              {
                name           = "Yandex​";
                definedAliases = [ "@y" ];
                urls           = [{ template = "https://yandex.com/search/?text={searchTerms}"; }];
              };
              # }}}

              # {{{ YouTube
              youtube =
              {
                name           = "YouTube​";
                definedAliases = [ "@yt" ];
                urls           = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
              };
              # }}}

              # {{{ Wikipedia
              wikipedia =
              {
                name           = "Wikipedia​";
                definedAliases = [ "@w" ];
                urls           = [{ template = "https://www.wikipedia.org/search-redirect.php?search={searchTerms}"; }];
              };
              # }}}

              # {{{ dexonline
              dexonline =
              {
                name           = "dexonline​";
                definedAliases = [ "@dex" ];
                urls           = [{ template = "https://dexonline.ro/search.php?cuv={searchTerms}"; }];
              };
              # }}}

              # {{{ NixOS Search (packages)
              nixos-search_packages =
              {
                name           = "NixOS Search (packages)​";
                definedAliases = [ "@nix" ];
                urls           = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
              };
              # }}}

              # {{{ NixOS Search (options)
              nixos-search_options =
              {
                name           = "NixOS Search (options)​";
                definedAliases = [ "@nixo" ];
                urls           = [{ template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; }];
              };
              # }}}

              # {{{ MyNixOS
              mynixos =
              {
                name           = "MyNixOS​";
                definedAliases = [ "@mnix" ];
                urls           = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
              };
              # }}}

              # {{{ MyNixOS (options)
              mynixos_options =
              {
                name           = "MyNixOS (options)​";
                definedAliases = [ "@mnixo" ];
                urls           = [{ template = "https://mynixos.com/search?q=option {searchTerms}"; }];
              };
              # }}}

              # {{{ Nix User Repository
              nix-user-repository =
              {
                name           = "Nix User Repository​";
                definedAliases = [ "@nur" ];
                urls           = [{ template = "https://nur.nix-community.org/?query={searchTerms}"; }];
              };
              # }}}

              # {{{ Nixpkgs Github Issues
              nixpkgs-github-issues =
              {
                name           = "Nixpkgs Github Issues​";
                definedAliases = [ "@nixi" ];
                urls           = [{ template = "https://github.com/NixOS/nixpkgs/issues?q={searchTerms}"; }];
              };
              # }}}

              # {{{ NixOS Wiki
              nixos-wiki =
              {
                name           = "NixOS Wiki​";
                definedAliases = [ "@nixw" ];
                urls           = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
              };
              # }}}

              # {{{ Arch Linux Wiki
              arch-linux-wiki =
              {
                name           = "Arch Linux Wiki​";
                definedAliases = [ "@archw" ];
                urls           = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
              };
              # }}}

              # {{{ Arch Linux Packages
              arch-linux-packages =
              {
                name           = "Arch Linux Packages​";
                definedAliases = [ "@arch" ];
                urls           = [{ template = "https://archlinux.org/packages/?sort=&q={searchTerms}"; }];
              };
              # }}}

              # {{{ Arch User Repository
              arch-user-repository =
              {
                name           = "Arch User Repository​";
                definedAliases = [ "@aur" ];
                urls           = [{ template = "https://aur.archlinux.org/packages?K={searchTerms}"; }];
              };
              # }}}

              # {{{ CTAN
              ctan =
              {
                name           = "CTAN​";
                definedAliases = [ "@ctan" ];
                urls           = [{ template = "https://ctan.org/search?phrase={searchTerms}"; }];
              };
              # }}}

              # {{{ Steam Store
              steam-store =
              {
                name           = "Steam Store​";
                definedAliases = [ "@steam" ];
                urls           = [{ template = "https://store.steampowered.com/search?term={searchTerms}"; }];
              };
              # }}}

              # {{{ ProtonDB
              protondb =
              {
                name           = "ProtonDB​";
                definedAliases = [ "@pdb" ];
                urls           = [{ template = "https://www.protondb.com/search?q={searchTerms}"; }];
              };
              # }}}

              # {{{ Terraria Wiki
              terraria-wiki =
              {
                name           = "Terraria Wiki​";
                definedAliases = [ "@tw" ];
                urls           = [{ template = "https://terraria.wiki.gg/wiki/Special:Search?search={searchTerms}"; }];
              };
              # }}}

              # {{{ Calamity Mod Wiki
              calamity-mod-wiki =
              {
                name           = "Calamity Mod Wiki​";
                definedAliases = [ "@cmw" ];
                urls           = [{ template = "https://calamitymod.wiki.gg/wiki/Special:Search?search={searchTerms}"; }];
              };
              # }}}

              # {{{ Stardew Valley Wiki
              stardew-valley-wiki =
              {
                name           = "Stardew Valley Wiki​";
                definedAliases = [ "@sdvw" ];
                urls           = [{ template = "https://stardewvalleywiki.com/mediawiki/index.php?search={searchTerms}"; }];
              };
              # }}}

              # {{{ Earthbound Wiki
              earthbound-wiki =
              {
                name           = "Earthbound Wiki​";
                definedAliases = [ "@ebw" ];
                urls           = [{ template = "https://earthbound.fandom.com/wiki/Special:Search?query={searchTerms}"; }];
              };
              # }}}

              # {{{ LinkedIn
              linkedin =
              {
                name           = "LinkedIn​";
                definedAliases = [ "@lin" ];
                urls           = [{ template = "https://www.linkedin.com/search/results/all/?keywords={searchTerms}"; }];
              };
              # }}}
            };
            # }}}
          };
          # }}}

          # {{{ Settings
          settings =
          {
            "browser.startup.page" = 3; # open previous windows and tabs on startup

            "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\"],\"nav-bar\":[\"sidebar-button\",\"firefox-view-button\",\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring2\",\"urlbar-container\",\"customizableui-special-spring3\",\"vertical-spacer\",\"library-button\",\"downloads-button\",\"unified-extensions-button\",\"alltabs-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[],\"vertical-tabs\":[\"tabbrowser-tabs\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"TabsToolbar\",\"vertical-tabs\",\"toolbar-menubar\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":4}";

            "browser.urlbar.showSearchSuggestionsFirst" = true;
            "browser.urlbar.suggest.searches"           = true;

            "identity.fxaccounts.account.device.name" = "${userName}'s LibreWolf on ${hostName}";

            "sidebar.backupState"                           = "{\"expandedLauncherWidth\":200}";
            "sidebar.verticalTabs"                          = true;
            "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            "sidebar.visibility"                            = "expand-on-hover";

            "widget.allow-client-side-decoration" = false;

            "widget.use-xdg-desktop-portal.file-picker"  = true;
            "widget.use-xdg-desktop-portal.location"     = true;
            "widget.use-xdg-desktop-portal.mime-handler" = true;
            "widget.use-xdg-desktop-portal.open-uri"     = true;
            "widget.use-xdg-desktop-portal.settings"     = true;
          };
          # }}}
        };
        # }}}

        # {{{ Settings
        settings =
        {
          "identity.fxaccounts.enabled" = true;

          "privacy.clearOnShutdown.cache"     = false;
          "privacy.clearOnShutdown.cookies"   = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.history"   = false;

          "webgl.disabled" = false;
        };
        # }}}
      };
    };
    # }}}
  };
}
