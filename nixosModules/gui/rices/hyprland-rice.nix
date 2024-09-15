## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland Rice
## https://github.com/Andy3153/hyprland-rice
##

{ config, lib, pkgs, my-pkgs, ... }:

let
  cfg = config.custom.gui.rices.hyprland-rice;
in
{
  options.custom.gui.rices.hyprland-rice.enable = lib.mkEnableOption "enables my Hyprland rice";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      gui =
      {
        wm.hyprland.enable = true; # Enable Hyprland

        # {{{ Theming
        theme =
        {
          # {{{ Font
          font =
          {
            generalFontSize = 11;
            fixedFontSize   = 12;

            extraFontPackages = with pkgs;
            [
              corefonts                           # fonts ms-fonts
              vistafonts                          # fonts ms-fonts
            ];

            defaultFonts =
            {
              monospace =
              {
                names    = [ "IosevkaTerm Nerd Font Mono" ];
                packages = with pkgs; [ (nerdfonts.override{ fonts = [ "IosevkaTerm" "Iosevka" ]; }) ];
              };

              serif =
              {
                names    = config.custom.gui.theme.font.defaultFonts.sansSerif.names;
                packages = config.custom.gui.theme.font.defaultFonts.sansSerif.packages;
              };

              sansSerif =
              {
                names    = [ "Cantarell" ];
                packages = with pkgs; [ cantarell-fonts ];
              };

              emoji =
              {
                names    = [ "Noto Color Emoji" ];
                packages = with pkgs; [ noto-fonts-color-emoji ];
              };
            };
          };
          # }}}

          # {{{ Icons
          icon =
          {
            name    = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders.override
            {
              flavor = "mocha";
              accent = "blue";
            };
          };
          # }}}

          # {{{ Cursor
          cursor =
          {
            package = pkgs.apple-cursor;
            name    = "macOS";
            #package = pkgs.catppuccin-cursors.mochaBlue;
            #name    = "Catppuccin-Mocha-Blue";
            size    = 24;
          };
          # }}}

          # {{{ GTK
          gtk =
          {
            name    = "catppuccin-mocha-blue-standard";
            package = pkgs.catppuccin-gtk.override
            {
              variant = "mocha";
              accents = [ "blue" ];
            };
          };
          # }}}

          # {{{ Qt
          qt.style.kvantum =
          {
            enable = true;
            theme =
            let
              catppuccinRepo = pkgs.fetchFromGitHub
              {
                owner = "catppuccin";
                repo  = "Kvantum";
                hash  = "sha256-aFS50Q6ezhiFU9ht14KUr/ZWskYMo8zi0IG4l/o7Bxk=";
                rev   = "a8d05868f8f0475d584949d4b82ebd33e9e68429";
              };

              themeName    = config.custom.gui.theme.qt.style.kvantum.theme.name;
              catppuccinVariant = "mocha";
              catppuccinAccent  = "blue";

              filePath = "${catppuccinRepo}/themes/${catppuccinVariant}/${catppuccinVariant}-${catppuccinAccent}/${catppuccinVariant}-${catppuccinAccent}";

              svgFile      = "${filePath}.svg";

              # {{{ kvconfig file
              # {{{ Differences from original
              #toolbutton_style=0
              #translucent_windows=true
              #animate_states=true
              #scrollable_menu=true
              #dialog_button_layout=1
              #reduce_menu_opacity=20
              #reduce_window_opacity=20
              #menu_blur_radius=0
              #tooltip_blur_radius=0
              #transparent_dolphin_view=true
              #transparent_pcmanfm_view=true
              #middle_click_scroll=true
              # }}}

              # {{{ File contents
              kvconfigContents = pkgs.writeTextFile
              {
                name = "${themeName}.kvconfig";
                text =
                ''
[%General]
author=elkrien based on Arc Dark style
comment=Catppuccin-Mocha-Blue
spread_menuitems=true
left_tabs=true
mirror_doc_tabs=true
scroll_width=8
attach_active_tab=true
composite=true
menu_shadow_depth=7
tooltip_shadow_depth=0
splitter_width=7
check_size=16
slider_width=4
slider_handle_width=18
slider_handle_length=18
textless_progressbar=false
menubar_mouse_tracking=true
slim_toolbars=false
toolbutton_style=0
x11drag=menubar_and_primary_toolbar
double_click=false
translucent_windows=true
blurring=false
popup_blurring=true
opaque=kaffeine,kmplayer,subtitlecomposer,kdenlive,vlc,smplayer,smplayer2,avidemux,avidemux2_qt4,avidemux3_qt4,avidemux3_qt5,kamoso,QtCreator,VirtualBox,trojita,dragon,digikam,qmplay2
group_toolbar_buttons=false
vertical_spin_indicators=false
fill_rubberband=false
spread_progressbar=true
merge_menubar_with_toolbar=true
small_icon_size=16
large_icon_size=32
button_icon_size=16
scroll_arrows=false
iconless_pushbutton=true
toolbar_icon_size=16
combo_as_lineedit=true
button_contents_shift=false
groupbox_top_label=true
inline_spin_indicators=true
joined_inactive_tabs=false
layout_spacing=2
submenu_overlap=0
tooltip_delay=-1
animate_states=true
transient_scrollbar=true
alt_mnemonic=true
combo_menu=true
layout_margin=4
no_window_pattern=false
respect_DE=true
scroll_min_extent=36
scrollable_menu=true
scrollbar_in_view=false
spin_button_width=16
submenu_delay=250
tree_branch_line=true
progressbar_thickness=8
click_behavior=0
contrast=1.00
dialog_button_layout=1
drag_from_buttons=false
hide_combo_checkboxes=false
intensity=1.00
no_inactiveness=false
reduce_menu_opacity=20
reduce_window_opacity=20
saturation=1.00
shadowless_popup=false
transient_groove=false
menu_blur_radius=0
tooltip_blur_radius=0

[GeneralColors]
window.color=#1E1E2E
base.color=#181825
alt.base.color=#181825
button.color=#313244
light.color=#45475A
mid.light.color=#45475A
dark.color=#181825
mid.color=#181825
highlight.color=#89B4FA
inactive.highlight.color=#89B4FA
text.color=#CDD6F4
window.text.color=#CDD6F4
button.text.color=#CDD6F4
disabled.text.color=#585B70
tooltip.text.color=#CDD6F4
highlight.text.color=#181825
link.color=#F5E0DC
link.visited.color=#89B4FA

[ItemView]
inherits=PanelButtonCommand
frame.element=itemview
interior.element=itemview
frame=true
interior=true
text.iconspacing=3
text.toggle.color=#181825

[RadioButton]
inherits=PanelButtonCommand
frame=false
interior.element=radio

[CheckBox]
inherits=PanelButtonCommand
frame=false
interior.element=checkbox

[TreeExpander]
indicator.element=tree
indicator.size=8

[ToolTip]
frame.top=4
frame.right=4
frame.bottom=4
frame.left=4
frame=true

[PanelButtonCommand]
inherits=PanelButtonCommand
interior.element=button
frame.element=button
text.normal.color=#CDD6F4
text.focus.color=#CDD6F4
text.press.color=#181825
text.toggle.color=#181825

[PanelButtonTool]
inherits=PanelButtonCommand

[DockTitle]
inherits=PanelButtonCommand
interior=false
frame=false
text.margin.top=5
text.margin.bottom=5
text.margin.left=5
text.margin.right=5
indicator.size=0

[Dock]
interior.element=toolbar
frame.element=toolbar
frame=true
interior=true

[GroupBox]
inherits=PanelButtonCommand
interior.element=tabframe
interior=true
frame=false

[Focus]
inherits=PanelButtonCommand
frame=true
frame.element=focus
frame.top=1
frame.bottom=1
frame.left=1
frame.right=1
frame.patternsize=20

[GenericFrame]
inherits=PanelButtonCommand
frame.element=common
frame.top=1
frame.bottom=1
frame.left=1
frame.right=1

[Slider]
inherits=PanelButtonCommand
interior=true
frame.element=slider
interior.element=slider
frame.top=3
frame.bottom=3
frame.left=3
frame.right=3
focusFrame=true

[SliderCursor]
inherits=PanelButtonCommand
interior=true
interior.element=slidercursor
frame=false

[LineEdit]
inherits=PanelButtonCommand
frame.element=lineedit
interior.element=lineedit

[IndicatorSpinBox]
inherits=LineEdit
frame.element=lineedit
interior.element=lineedit
frame.top=0
frame.bottom=2
frame.left=2
frame.right=2
indicator.size=8

[DropDownButton]
inherits=PanelButtonCommand
frame.top=2
frame.bottom=2
frame.left=0
frame.right=1
indicator.size=8

[ToolboxTab]
inherits=PanelButtonCommand
frame.element=tabframe
frame.top=1
frame.bottom=1
frame.left=1
frame.right=1

[Tab]
inherits=PanelButtonCommand
interior.element=tab
frame.element=tab
frame.top=2
frame.bottom=3
frame.left=3
frame.right=3
indicator.size=10
text.normal.color=#585B70
text.focus.color=#CDD6F4
text.press.color=#CDD6F4
text.toggle.color=#CDD6F4
focusFrame=true

[TabBarFrame]
inherits=GenericFrame
frame=true
frame.element=tabBarFrame
interior=false
frame.top=4
frame.bottom=4
frame.left=4
frame.right=4

[TabFrame]
inherits=PanelButtonCommand
frame.element=tabframe
interior.element=tabframe

[Dialog]
inherits=TabBarFrame
frame.element=tabframe
interior=false
frame=false
frame.top=1
frame.bottom=1
frame.left=1
frame.right=1

[HeaderSection]
inherits=PanelButtonCommand
interior.element=header
frame.element=header
frame.top=0
frame.bottom=1
frame.left=1
frame.right=1
frame.expansion=0
text.normal.color=#CDD6F4
text.focus.color=#89B4FA
text.press.color=#CDD6F4
text.toggle.color=#CDD6F4
indicator.element=harrow

[SizeGrip]
inherits=PanelButtonCommand
frame=false
interior=false
indicator.element=resize-grip
indicator.size=0

[Toolbar]
inherits=PanelButtonCommand
interior.element=menubar
frame.element=menubar
frame=true
frame.bottom=4
frame.left=4
frame.right=4
text.normal.color=#CDD6F4
text.focus.color=#CDD6F4
text.press.color=#89B4FA
text.toggle.color=#89B4FA
text.bold=false

[MenuBar]
inherits=PanelButtonCommand
frame.element=menubar
interior.element=menubar
frame.bottom=0
text.normal.color=#CDD6F4
frame.expansion=0
text.bold=false

[ToolbarButton]
frame.element=tbutton
interior.element=tbutton
indicator.element=arrow
text.normal.color=#CDD6F4
text.focus.color=#CDD6F4
text.press.color=#181825
text.toggle.color=#181825
text.bold=false

[Scrollbar]
inherits=PanelButtonCommand
indicator.size=0
interior=false
frame=false

[ScrollbarGroove]
inherits=PanelButtonCommand
interior=false
frame=false

[ScrollbarSlider]
inherits=PanelButtonCommand
interior=false
frame.element=scrollbarslider
frame.top=4
frame.bottom=4
frame.left=4
frame.right=4

[ProgressbarContents]
inherits=PanelButtonCommand
frame=true
frame.element=progress-pattern
interior.element=progress-pattern
frame.top=2
frame.bottom=2
frame.left=2
frame.right=2

[Progressbar]
inherits=PanelButtonCommand
frame.element=progress
interior.element=progress
frame.top=2
frame.bottom=2
frame.left=2
frame.right=2
text.margin=0
text.normal.color=#CDD6F4
text.focus.color=#CDD6F4
text.press.color=#181825
text.toggle.color=#181825
text.bold=false
frame.expansion=18

[RadioButton]
inherits=PanelButtonCommand

[Menu]
frame.element=menu
interior.element=menu
inherits=PanelButtonCommand
text.press.color=#181825
text.toggle.color=#181825
text.bold=false
frame.top=3
frame.bottom=3
frame.left=3
frame.right=3

[MenuItem]
inherits=PanelButtonCommand
interior.element=menuitem
indicator.size=8
text.focus.color=#CDD6F4
text.press.color=#CDD6F4

[MenuBarItem]
inherits=PanelButtonCommand
interior.element=menubaritem
frame=false
text.margin.top=3
text.margin.bottom=3
text.margin.left=5
text.margin.right=5

[StatusBar]
inherits=Toolbar
frame.element=toolbar
font.bold=true
text.normal.color=#CDD6F4
frame=true
frame.top=0
frame.bottom=0

[TitleBar]
inherits=PanelButtonCommand
frame=false
interior=false
text.margin.top=2
text.margin.bottom=2
text.margin.left=3
text.margin.right=3

[ComboBox]
inherits=PanelButtonCommand
indicator.size=8
frame.top=3
frame.bottom=3
frame.left=3
frame.right=3
text.margin.top=1
text.margin.bottom=1
text.margin.left=3
text.margin.right=3
text.toggle.color=#CDD6F4

[ToolboxTab]
inherits=PanelButtonCommand
text.normal.color=#CDD6F4
text.press.color=#CDD6F4
text.focus.color=#CDD6F4

[Hacks]
transparent_dolphin_view=true
blur_konsole=true
transparent_ktitle_label=true
transparent_menutitle=true
respect_darkness=true
kcapacitybar_as_progressbar=true
force_size_grip=false
iconless_pushbutton=true
iconless_menu=false
disabled_icon_opacity=100
lxqtmainmenu_iconsize=0
normal_default_pushbutton=true
single_top_toolbar=false
tint_on_mouseover=0
transparent_pcmanfm_sidepane=true
transparent_pcmanfm_view=true
blur_translucent=true
centered_forms=false
kinetic_scrolling=false
middle_click_scroll=true
no_selection_tint=false
noninteger_translucency=false
style_vertical_toolbars=false
blur_only_active_window=false

[Window]
interior=true
interior.element=window
frame.top=0
frame.bottom=0
frame.left=0
frame.right=0
                '';
              };
              # }}}

              kvconfigFile     = "${kvconfigContents}";
              # }}}
            in
            {
              name         = "Catppuccin-Mocha-Blue";
              kvconfigFile = kvconfigFile;
              svgFile      = svgFile;
            };
          };
          # }}}
        };
        # }}}
      };

      # {{{ Extra packages
      extraPackages = lib.lists.flatten
      [
        # {{{ Default NixPkgs
        (with pkgs;
        [
          libcanberra-gtk3                     # hyprland-rice play-system-sounds
          hyprpaper                            # hyprland-rice wallpaper
          hypridle                             # hyprland-rice idle-manager
          hyprlock                             # hyprland-rice lock-screen
          hyprpicker                           # hyprland-rice color-picker
          swayosd                              # hyprland-rice osd
          wl-clipboard                         # hyprland-rice for-zsh for-nvim clipboard
          polkit-kde-agent                     # hyprland-rice polkit-agent
          xwaylandvideobridge                  # hyprland-rice xwayland-screenshare
          wev                                  # hyprland-rice event-viewer
          rofi-wayland                         # hyprland-rice appmenu
          kitty                                # hyprland-rice terminal
          waybar                               # hyprland-rice status-bar
          blueman                              # hyprland-rice bluetooth-control
          networkmanager_dmenu                 # hyprland-rice network-control
          lxqt.pavucontrol-qt                  # hyprland-rice Sound sound-control
          nwg-bar                              # hyprland-rice logout-menu
          flameshot                            # hyprland-rice screenshot
          grim                                 # hyprland-rice screenshot for-flameshot
          slurp                                # hyprland-rice screenshot for-flameshot

          zathura                              # hyprland-rice pdf-viewer
        ])

        (with pkgs.kdePackages;
        [
          dolphin                  # hyprland-rice KDE-Apps file-manager
          kio                      # for-dolphin
          kio-extras               # for-dolphin
          kimageformats            # for-dolphin
          kdegraphics-thumbnailers # for-dolphin

          kcalc                    # hyprland-rice KDE-Apps calculator
          kdeconnect-kde           # hyprland-rice KDE-Apps
          ark                      # hyprland-rice KDE-Apps archive-manager
          gwenview                 # hyprland-rice KDE-Apps image-viewer
          okular                   # hyprland-rice KDE-Apps pdf-viewer
          kcharselect              # hyprland-rice KDE-Apps character-select
          filelight                # hyprland-rice KDE-Apps disk-usage-analyzer
          kruler                   # hyprland-rice KDE-Apps on-screen-ruler
          merkuro                  # hyprland-rice KDE-Apps calendar contacts
        ])
        # }}}

        # {{{ My Nix packages
        (with my-pkgs;
        [
          weather4bar                         # hyprland-rice my-scripts for-waybar
          batnotifsd                          # hyprland-rice my-scripts
        ])
        # }}}
      ];
      # }}}

      # {{{ Programs
      programs.mpv.enable = true;              # hyprland-rice video-player
      # }}}

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "apple_cursor"
        "corefonts"
        "vista-fonts"
      ];
      # }}}
    };

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    # {{{ Config files
    home.file =
    {
      ".config/btop".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/btop;
      #".config/cava".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/cava;
      ".config/css-common".source                               = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/css-common;
      ".config/dunst".source                                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/dunst;
      ".config/fastfetch".source                                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fastfetch;
      ".config/flameshot".source                                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/flameshot;
      ##".config/fontconfig".source                               = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fontconfig;
      #".config/fuzzel".source                                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fuzzel;
      ##".config/gtk-2.0".source                                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/gtk-2.0;
      ##".config/gtk-3.0".source                                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/gtk-3.0;
      ".config/htop".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/htop;
      ".config/hypr".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/hypr;
      ".config/kitty".source                                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/kitty;
      #".config/lf".source                                       = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/lf;
      ".config/mpv".source                                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/mpv;
      ".config/networkmanager-dmenu".source                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/networkmanager-dmenu;
      ".config/nwg-bar".source                                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-bar;
      #".config/nwg-dock-hyprland".source                        = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-dock-hyprland;
      #".config/nwg-drawer".source                               = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-drawer;
      ##".config/qt5ct".source                                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ##".config/qt6ct".source                                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ".config/rofi".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/rofi;
      #".config/swayidle".source                                 = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swayidle;
      #".config/swaylock".source                                 = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swaylock;
      #".config/swaync".source                                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swaync;
      ".config/waybar".source                                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/waybar;
      #".config/xava".source                                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/xava;
      ".config/xdg-desktop-portal/hyprland-portals.conf".source = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/xdg-desktop-portal;
      ".config/zathura".source                                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/zathura;

      ".local/share/sounds".source                              = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/sounds;
      ".local/share/wallpapers".source                          = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers;

      ".local/share/wallpaper.png".source                       = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers/wallpaper5.png; # these basically set your wallpaper
      ".local/share/wallpaper-lock.png".source                  = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers/wallpaper5.png;

      ".local/bin/checkFan.sh".source                           = /home/andy3153/src/sh/other-shell-scripts/checkFan.sh;
      ".local/bin/suspend_compositing.sh".source                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/hypr/scripts/suspend_compositing.sh;
      ".local/bin/launch-waybar".source                         = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/waybar/launch-waybar;
      ".local/bin/launch-kdepolkitagent".source                 = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/hypr/scripts/launch-kdepolkitagent;
    };
    # }}}

    # {{{ Services
    services.dunst.enable = true;  # hyprland-rice notification-daemon
    # }}}
  };
  # }}}
  };
}
