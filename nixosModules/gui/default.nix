## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI bundle
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui;
in
{
  imports =
  [
    ./dm
    ./theme
    ./wm
    ./apps.nix
    ./gaming.nix
  ];

  options.custom.gui.enable = lib.mkEnableOption "enables a GUI";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      boot.plymouth.enable = lib.mkDefault true;

      gui =
      {
        apps.enable                 = lib.mkDefault true;

        gaming.enable               = lib.mkDefault false;
        gaming.optimizations.enable = lib.mkDefault config.custom.gui.gaming.enable;

        theme =
        {
          cursor =
          {
            package = pkgs.apple-cursor;
            name    = "macOS-Monterey";
            size    = 24;
          };

          font =
          {
            generalFontSize = 11;
            fixedFontSize   = 12;

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

          gtk =
          {
            name    = "Catppuccin-Mocha-Standard-Blue-Dark";
            package = pkgs.catppuccin-gtk.override
            {
              variant = "mocha";
              accents = [ "blue" ];
            };
          };

          icon =
          {
            name    = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders.override
            {
              flavor = "mocha";
              accent = "blue";
            };
          };

          qt.style.kvantum =
          {
            enable = lib.mkDefault true;
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
        };

        wm.hyprland.enable          = lib.mkDefault true;
      };

      hardware.opengl.enable  = lib.mkDefault true;
      programs.dconf.enable   = lib.mkDefault true;
      services.udisks2.enable = lib.mkDefault true;

      xdg =
      {
        enable        = lib.mkDefault true;
        portal.enable = lib.mkDefault true;
        mime =
        {
          enable = lib.mkDefault true;
          defaultApplications =
          let
            # {{{ Default applications
            ##
            ## All .desktop files live inside folders from $XDG_DATA_DIRS
            ##

            browser                        = "io.gitlab.librewolf-community.desktop";
            fileManager                    = "org.kde.dolphin.desktop";
            textEditor                     = "neovide.desktop";
            docViewer                      = "org.pwmt.zathura.desktop";
            docEditor.document.opendoc     = "writer.desktop";
            docEditor.document.ms          = docEditor.document.opendoc;
            docEditor.spreadsheet.opendoc  = "calc.desktop";
            docEditor.spreadsheet.ms       = docEditor.spreadsheet.opendoc;
            docEditor.presentation.opendoc = "impress.desktop";
            docEditor.presentation.ms      = docEditor.presentation.opendoc;
            imgViewer                      = "org.kde.gwenview.desktop";
            imgEditor.raster               = "gimp.desktop";
            imgEditor.vector               = "org.inkscape.Inkscape.desktop";
            imgEditor.drawing              = "krita-2.desktop";
            vidViewer                      = "mpv.desktop";
            archive                        = "org.kde.ark.desktop";
            winProgs                       = "com.usebottles.bottles.desktop";
            torrent                        = "org.qbittorrent.qBittorrent.desktop";
            # }}}
          in
          {
            # {{{ Assigning of MIMEtypes from default applications
            # {{{ Browser
            #"application/rss+xml"      = browser;
            #"application/x-xpinstall"  = browser;
            #"application/xhtml+xml"    = browser;
            "x-scheme-handler/http"    = browser;
            "x-scheme-handler/https"   = browser;
            "x-scheme-handler/about"   = browser;
            "x-scheme-handler/unknown" = browser;
            # }}}

            # {{{ File manager
            "inode/directory" = fileManager;
            # }}}

            # {{{ Text editor
            "application/json"          = textEditor;
            "application/schema+json"   = textEditor;
            "application/x-cdrdao-toc"  = textEditor;
            "application/x-perl"        = textEditor;
            "application/x-shellscript" = textEditor;
            "application/x-troff-man"   = textEditor;
            "application/x-zerosize"    = textEditor;
            "application/xml"           = textEditor;
            "text/css"                  = textEditor;
            "text/html"                 = textEditor;
            "text/markdown"             = textEditor;
            "text/plain"                = textEditor;
            "text/x-c++src"             = textEditor;
            "text/x-chdr"               = textEditor;
            "text/x-cmake"              = textEditor;
            "text/x-csrc"               = textEditor;
            "text/x-devicetree-source"  = textEditor;
            "text/x-lua"                = textEditor;
            "text/x-makefile"           = textEditor;
            "text/x-meson"              = textEditor;
            "text/x-nfo"                = textEditor;
            "text/x-python3"            = textEditor;
            "text/x-readme"             = textEditor;
            "text/x-tex"                = textEditor;
            # }}}

            # {{{ Document viewer
            "application/pdf"               = docViewer;
            "application/vnd.comicbook+zip" = docViewer;
            "image/vnd.djvu"                = docViewer;
            "image/vnd.djvu+multipage"      = docViewer;
            # }}}

            # {{{ Document editor
            "application/msword"                                                        = docEditor.document.ms;
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document"   = docEditor.document.ms;
            "application/vnd.oasis.opendocument.text"                                   = docEditor.document.opendoc;
            "application/rtf"                                                           = docEditor.document.opendoc;

            "application/msexcel"                                                       = docEditor.spreadsheet.ms;
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"         = docEditor.spreadsheet.ms;
            "application/vnd.oasis.opendocument.spreadsheet"                            = docEditor.spreadsheet.opendoc;
            "text/csv"                                                                  = docEditor.spreadsheet.opendoc;

            "application/mspowerpoint"                                                  = docEditor.presentation.ms;
            "application/vnd.openxmlformats-officedocument.presentationml.presentation" = docEditor.presentation.ms;
            "application/vnd.oasis.opendocument.presentation"                           = docEditor.presentation.opendoc;
            # }}}

            # {{{ Image viewer
            "image/avif"                     = imgViewer;
            "image/bmp"                      = imgViewer;
            "image/gif"                      = imgViewer;
            "image/heif"                     = imgViewer;
            "image/jpeg"                     = imgViewer;
            "image/jp2"                      = imgViewer;
            "image/jpm"                      = imgViewer;
            "image/jpx"                      = imgViewer;
            "image/jxl"                      = imgViewer;
            "image/png"                      = imgViewer;
            "image/tiff"                     = imgViewer;
            "image/webp"                     = imgViewer;
            "image/image/vnd.microsoft.icon" = imgViewer;
            "image/x-dcraw"                  = imgViewer;
            "image/x-icns"                   = imgViewer;
            "image/x-xcursor"                = imgViewer;
            # }}}

            # {{{ Image editor
            "image/vnd.adobe.photoshop" = imgEditor.raster;
            "image/x-xcf"               = imgEditor.raster;
            "image/x-compressed-xcf"    = imgEditor.raster;

            "image/svg+xml"             = imgEditor.vector;
            "image/svg+xml-compressed"  = imgEditor.vector;

            "application/x-krita"       = imgEditor.drawing;
            # }}}

            # {{{ Video viewer
            "application/x-matroska" = vidViewer;
            "video/avi"              = vidViewer;
            "video/flv"              = vidViewer;
            "video/mp4"              = vidViewer;
            "video/mpeg"             = vidViewer;
            "video/webm"             = vidViewer;
            "video/vnd.avi"          = vidViewer;
            #"video/x-avi"            = vidViewer;
            #"video/x-matroska"       = vidViewer;
            #"video/x-mpeg"           = vidViewer;
            #"video/x-flv"            = vidViewer;
            # }}}

            # {{{ Archive
            "application/gzip"             = archive;
            "application/vnd.rar"          = archive;
            "application/x-7z-compressed"  = archive;
            "application/x-compressed-tar" = archive;
            "application/x-tar"            = archive;
            "application/zip"              = archive;
            # }}}

            # {{{ Windows programs
            "application/x-ms-shortcut"        = winProgs;
            "application/x-wine-extension-msp" = winProgs;
            "application/x-msdownload"         = winProgs;
            "application/x-msi"                = winProgs;
            # }}}

            # {{{ Torrent
            "application/x-bittorrent" = torrent;
            "x-scheme-handler/magnet"  = torrent;
            # }}}
            # }}}
          };
        };
      };
    };
  };
}
