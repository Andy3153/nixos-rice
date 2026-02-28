## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Vesktop config
##

{ config, lib, ... }:

let
  cfg      = config.custom.programs.vesktop;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.programs.vesktop.enable = lib.mkEnableOption "enables Vesktop";
  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      programs.vesktop =
      {
        enable = true;

        # {{{ Settings
        settings =
        {
          arRPC = true;
          clickTrayToShowHide = false;
          discordBranch = "stable";
          enableMenu = true;
          hardwareAcceleration = true;
          hardwareVideoAcceleration = true;
          minimizeToTray = false;
          splashPixelated = false;
          staticTitle = false;
          transparencyOption = "acrylic";
        };
        # }}}

        # {{{ Vencord
        vencord =
        {
          # {{{ Settings
          settings =
          {
            autoUpdate             = true;
            autoUpdateNotification = true;

            # {{{ Cloud
            cloud =
            {
              authenticated = true;
              url = "https://api.vencord.dev/";
              settingsSync = true;
              settingsSyncVersion = 1772271430835;
            };
            # }}}

            disableMinSize      = false;
            eagerPatches        = false;
            enableReactDevtools = true;
            frameless           = false;

            # {{{ Notifications
            notifications =
            {
              timeout = 3000;
              position = "top-right";
              useNative = "not-focused";
              logLimit = 50;
            };
            # }}}

            # {{{ Plugins
            plugins =
            {
              AlwaysAnimate.enabled              = true;
              AlwaysExpandRoles.enabled          = true;
              BadgeAPI.enabled                   = true;
              BetterGifAltText.enabled           = true;
              BetterGifPicker.enabled            = true;
              BiggerStreamPreview.enabled        = true;
              ChatInputButtonAPI.enabled         = true;
              ClearURLs.enabled                  = true;
              CommandsAPI.enabled                = true;
              CopyFileContents.enabled           = true;
              CopyStickerLinks.enabled           = true;
              CopyUserURLs.enabled               = true;
              Decor.enabled                      = true;
              DisableCallIdle.enabled            = true;
              DisableDeepLinks.enabled           = true;
              DynamicImageModalAPI.enabled       = true;
              ExpressionCloner.enabled           = true;
              FavoriteEmojiFirst.enabled         = true;
              FixYoutubeEmbeds.enabled           = true;
              ForceOwnerCrown.enabled            = true;
              FriendsSince.enabled               = true;
              FullSearchContext.enabled          = true;
              FullUserInChatbox.enabled          = true;
              GifPaste.enabled                   = true;
              ImageLink.enabled                  = true;
              MemberListDecoratorsAPI.enabled    = true;
              MessageAccessoriesAPI.enabled      = true;
              MessageDecorationsAPI.enabled      = true;
              MessageEventsAPI.enabled           = true;
              MessagePopoverAPI.enabled          = true;
              MessageUpdaterAPI.enabled          = true;
              MutualGroupDMs.enabled             = true;
              NoDevtoolsWarning.enabled          = true;
              NoF1.enabled                       = true;
              NoUnblockToJump.enabled            = true;
              PermissionsViewer.enabled          = true;
              ReadAllNotificationsButton.enabled = true;
              ReplyTimestamp.enabled             = true;
              RevealAllSpoilers.enabled          = true;
              ReverseImageSearch.enabled         = true;
              SendTimestamps.enabled             = true;
              ServerInfo.enabled                 = true;
              ServerListAPI.enabled              = true;
              SpotifyShareCommands.enabled       = true;
              StartupTimings.enabled             = true;
              StickerPaste.enabled               = true;
              SupportHelper.enabled              = true;
              UnsuppressEmbeds.enabled           = true;
              UserSettingsAPI.enabled            = true;
              ValidReply.enabled                 = true;
              ValidUser.enabled                  = true;
              VoiceDownload.enabled              = true;
              WebContextMenus.enabled            = true;
              WebKeybinds.enabled                = true;
              WebScreenShareFixes.enabled        = true;
              WhoReacted.enabled                 = true;
              YoutubeAdblock.enabled             = true;
              iLoveSpam.enabled                  = true;
              petpet.enabled                     = true;

              AccountPanelServerProfile =
              {
                enabled = true;
                prioritizeServerProfile = false;
              };

              AnonymiseFileNames =
              {
                enabled = true;
                anonymiseByDefault = false;
                method = 0;
                randomisedLength = 7;
                consistent = "image";
              };

              BetterFolders =
              {
                enabled = true;
                sidebar = true;
                sidebarAnim = true;
                closeAllFolders = false;
                closeAllHomeButton = false;
                closeOthers = false;
                forceOpen = false;
                keepIcons = false;
                showFolderIcon = 1;
              };

              BetterRoleContext =
              {
                enabled = true;
                roleIconFileFormat = "png";
              };

              BetterRoleDot =
              {
                enabled = true;
                bothStyles = true;
                copyRoleColorInProfilePopout = true;
              };

              BetterSessions =
              {
                enabled = true;
                backgroundCheck = true;
                checkInterval = 20;
              };

              CallTimer =
              {
                enabled = true;
                format = "stopwatch";
              };

              CrashHandler =
              {
                enabled = true;
                attemptToPreventCrashes = true;
                attemptToNavigateToHome = false;
              };

              CustomIdle =
              {
                enabled = true;
                idleTimeout = 7.256317689530686;
                remainInIdle = true;
              };

              Experiments =
              {
                enabled = true;
                toolbarDevMenu = true;
              };

              FakeNitro =
              {
                enabled = true;
                enableEmojiBypass = true;
                emojiSize = 48;
                transformEmojis = true;
                enableStickerBypass = true;
                stickerSize = 160;
                transformStickers = true;
                transformCompoundSentence = false;
                enableStreamQualityBypass = true;
                useHyperLinks = true;
                hyperLinkText = "{{NAME}}";
                disableEmbedPermissionCheck = false;
              };

              FavoriteGifSearch =
              {
                enabled = true;
                searchOption = "hostandpath";
              };

              FixImagesQuality =
              {
                enabled = true;
                originalImagesInChat = false;
              };

              FixSpotifyEmbeds =
              {
                enabled = true;
                volume = 10;
              };

              GameActivityToggle =
              {
                enabled = true;
                oldIcon = false;
                location = "PANEL";
              };

              GreetStickerPicker =
              {
                enabled = true;
                greetMode = "Greet";
              };

              ImageFilename =
              {
                enabled = true;
                showFullUrl = false;
              };

              ImageZoom =
              {
                enabled = true;
                saveZoomValues = true;
                invertScroll = true;
                nearestNeighbour = false;
                square = false;
                zoom = 2;
                size = 100;
                zoomSpeed = 0.5;
              };

              ImplicitRelationships =
              {
                enabled = true;
                sortByAffinity = true;
              };

              MemberCount =
              {
                enabled = true;
                memberList = true;
                toolTip = true;
                voiceActivity = true;
              };

              MentionAvatars =
              {
                enabled = true;
                showAtSymbol = false;
              };

              MessageClickActions =
              {
                enabled = true;
                enableDeleteOnClick = true;
                enableDoubleClickToEdit = true;
                enableDoubleClickToReply = true;
                requireModifier = false;
              };

              MessageLatency =
              {
                enabled = true;
                latency = 1.2;
                detectDiscordKotlin = true;
                showMillis = false;
                ignoreSelf = false;
              };

              MessageLogger =
              {
                enabled = true;
                deleteStyle = "text";
                logDeletes = true;
                collapseDeleted = false;
                logEdits = true;
                inlineEdits = true;
                ignoreBots = true;
                ignoreSelf = false;
                ignoreUsers = "";
                ignoreChannels = "";
                ignoreGuilds = "";
              };

              NotificationVolume =
              {
                enabled = true;
                notificationVolume = 100;
              };

              OpenInApp =
              {
                enabled = true;
                spotify = true;
                steam = true;
                epic = false;
                tidal = false;
                itunes = false;
              };

              PictureInPicture =
              {
                enabled = true;
                loop = true;
              };

              PinDMs =
              {
                enabled = true;
                canCollapseDmSection = false;
              };

              PlatformIndicators =
              {
                enabled = true;
                list = true;
                badges = true;
                messages = true;
                colorMobileIndicator = true;
              };

              RelationshipNotifier =
              {
                enabled = true;
                notices = true;
                offlineRemovals = true;
                friends = true;
                friendRequestCancels = true;
                servers = true;
                groups = true;
              };

              ReplaceGoogleSearch =
              {
                enabled = true;
                replacementEngine = "Brave";
                customEngineName = "Brave Search";
                customEngineURL = "https://search.brave.com/search?q=";
              };

              RoleColorEverywhere =
              {
                enabled = true;
                chatMentions = true;
                memberList = true;
                voiceUsers = true;
                reactorsList = true;
                pollResults = true;
                colorChatMessages = false;
                messageSaturation = 30;
              };

              ShowHiddenChannels =
              {
                enabled = true;
                hideUnreads = true;
                showMode = 1;
                defaultAllowedUsersAndRolesDropdownState = true;
              };

              ShowHiddenThings =
              {
                enabled = true;
                showTimeouts = true;
                showInvitesPaused = true;
                showModView = true;
              };

              ShowMeYourName =
              {
                enabled = true;
                mode = "nick-user";
                friendNicknames = "dms";
                displayNames = false;
                inReplies = true;
              };

              SortFriendRequests =
              {
                enabled = true;
                showDates = true;
              };

              SpotifyControls =
              {
                enabled = true;
                hoverControls = false;
                useSpotifyUris = false;
                previousButtonRestartsTrack = true;
              };

              SpotifyCrack =
              {
                enabled = true;
                noSpotifyAutoPause = true;
                keepSpotifyActivityOnIdle = true;
              };

              Translate =
              {
                enabled = true;
                service = "google";
                deeplApiKey = "";
                autoTranslate = false;
                showAutoTranslateTooltip = true;
              };

              TypingIndicator =
              {
                enabled = true;
                includeCurrentChannel = true;
                includeMutedChannels = true;
                includeBlockedUsers = true;
                indicatorMode = 3;
              };

              TypingTweaks =
              {
                enabled = true;
                showAvatars = true;
                showRoleColors = true;
                alternativeFormatting = true;
              };

              UnlockedAvatarZoom =
              {
                enabled = true;
                zoomMultiplier = 4;
              };

              UserMessagesPronouns =
              {
                enabled = true;
                pronounsFormat = "LOWERCASE";
                showSelf = true;
              };

              UserVoiceShow =
              {
                enabled = true;
                showInUserProfileModal = true;
                showInMemberList = true;
                showInMessages = true;
              };

              VencordToolbox =
              {
                enabled = true;
                showPluginMenu = true;
              };

              ViewIcons =
              {
                enabled = true;
                format = "png";
                imgSize = "1024";
              };

              ViewRaw =
              {
                enabled = true;
                clickMethod = "Right";
              };

              VoiceMessages =
              {
                enabled = true;
                noiseSuppression = true;
                echoCancellation = true;
              };

              VolumeBooster =
              {
                enabled = true;
                multiplier = 3;
              };

              NoTrack =
              {
                enabled = true;
                disableAnalytics = true;
              };

              Settings =
              {
                enabled = true;
                settingsLocation = "aboveNitro";
              };
            };
            # }}}

            themeLinks        = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
            transparent       = true;
            useQuickCss       = true;
            winCtrlQ          = false;
            winNativeTitleBar = false;
          };
          # }}}

          useSystem = true;
        };
        # }}}
      };

      services.arrpc.enable = true;
    };
    # }}}
  };
}
