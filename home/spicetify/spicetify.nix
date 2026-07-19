{
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  c = config.lib.stylix.colors;

  lainRoseTheme = pkgs.stdenvNoCC.mkDerivation {
    name = "lain-rose";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out

      cat > $out/color.ini << EOF
      [lain-rose]
      text              = ${c.base06}
      subtext           = ${c.base07}
      sidebar-text      = ${c.base06}
      main              = ${c.base00}
      sidebar           = ${c.base01}
      player            = ${c.base01}
      card              = ${c.base02}
      shadow            = ${c.base00}
      selected-row      = ${c.base02}
      button            = ${c.base0E}
      button-active     = ${c.base05}
      button-disabled   = ${c.base04}
      tab-active        = ${c.base02}
      notification      = ${c.base0E}
      notification-error = ${c.base08}
      misc              = ${c.base09}
      EOF

      cat > $out/user.css << 'CSSEOF'
      :root,
      .Root__right-sidebar,
      .Root__right-sidebar * {
        --spice-subtext: #faeaec !important;
        --encore-secondary-text: #faeaec !important;
        --text-subdued: #faeaec !important;
        --text-base: #edbac3 !important;
      }

      /* Force readable text color directly in Friend Activity */
      .Root__right-sidebar * {
        color: #c87888 !important;
      }
      .Root__right-sidebar strong,
      .Root__right-sidebar [class*="name"],
      .Root__right-sidebar [class*="Name"],
      .Root__right-sidebar [class*="title"],
      .Root__right-sidebar [class*="Title"] {
        color: #faeaec !important;
      }

      .Root__main-view {
        background: #000000 !important;
      }

      .Root__nav-bar,
      .Root__top-bar {
        background: #100008 !important;
      }

      /* Now-playing bar */
      .Root__now-playing-bar {
        background: #100008 !important;
        border-top: 1px solid rgba(212, 104, 140, 0.3) !important;
      }

      /* Top bar */
      .Root__top-bar header {
        background: #100008 !important;
      }

      /* Left sidebar nav */
      .Root__nav-bar > nav,
      .Root__nav-bar > .nav-alt {
        background: #100008 !important;
      }

      /* Cards */
      .main-card-card {
        background: #1f0e16 !important;
        transition: background 0.2s ease !important;
      }

      .main-card-card:hover {
        background: #2a1020 !important;
      }

      /* Context menus / dropdowns */
      .main-contextMenu-menu,
      .x-filterBox-filterInput {
        background: #1f0e16 !important;
        border: 1px solid rgba(212, 104, 140, 0.25) !important;
      }

      /* Player control icons — brighten against dark now-playing bar */
      .Root__now-playing-bar button svg,
      .Root__now-playing-bar button path {
        fill: #faeaec !important;
      }
      .Root__now-playing-bar button {
        opacity: 1 !important;
      }
      /* Icon-only buttons (shuffle, download, invite, ...) draw their SVGs
         with currentColor on dark backgrounds — keep them light */
      button {
        color: #edbac3 !important;
      }
      /* Dark text only on buttons with light rose filled backgrounds */
      .encore-bright-accent-set button,
      [data-encore-id="buttonPrimary"],
      [class*="button"][class*="filled"],
      [class*="Button"][class*="filled"] {
        color: #000000 !important;
      }
      CSSEOF
    '';
  };
in {
  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "lain-rose";
      src = lainRoseTheme;
    };
    colorScheme = "lain-rose";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };
}
