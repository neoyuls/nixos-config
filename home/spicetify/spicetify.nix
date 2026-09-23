{
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  c = config.lib.stylix.colors;

  mikuStarsTheme = pkgs.stdenvNoCC.mkDerivation {
    name = "miku-stars";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out

      cat > $out/color.ini << EOF
      [miku-stars]
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
        --spice-subtext: #eef6ff !important;
        --encore-secondary-text: #eef6ff !important;
        --text-subdued: #eef6ff !important;
        --text-base: #cfe3f7 !important;
      }

      /* Force readable text color directly in Friend Activity */
      .Root__right-sidebar * {
        color: #a8c8e8 !important;
      }
      .Root__right-sidebar strong,
      .Root__right-sidebar [class*="name"],
      .Root__right-sidebar [class*="Name"],
      .Root__right-sidebar [class*="title"],
      .Root__right-sidebar [class*="Title"] {
        color: #eef6ff !important;
      }

      .Root__main-view {
        background: #0b0d13 !important;
      }

      .Root__nav-bar,
      .Root__top-bar {
        background: #141b2b !important;
      }

      /* Now-playing bar */
      .Root__now-playing-bar {
        background: #141b2b !important;
        border-top: 1px solid rgba(109, 227, 229, 0.3) !important;
      }

      /* Top bar */
      .Root__top-bar header {
        background: #141b2b !important;
      }

      /* Left sidebar nav */
      .Root__nav-bar > nav,
      .Root__nav-bar > .nav-alt {
        background: #141b2b !important;
      }

      /* Cards */
      .main-card-card {
        background: #1e2c47 !important;
        transition: background 0.2s ease !important;
      }

      .main-card-card:hover {
        background: #26365a !important;
      }

      /* Context menus / dropdowns */
      .main-contextMenu-menu,
      .x-filterBox-filterInput {
        background: #1e2c47 !important;
        border: 1px solid rgba(109, 227, 229, 0.25) !important;
      }

      /* Player control icons — brighten against dark now-playing bar */
      .Root__now-playing-bar button svg,
      .Root__now-playing-bar button path {
        fill: #eef6ff !important;
      }
      .Root__now-playing-bar button {
        opacity: 1 !important;
      }
      /* Icon-only buttons (shuffle, download, invite, ...) draw their SVGs
         with currentColor on dark backgrounds — keep them light */
      button {
        color: #cfe3f7 !important;
      }
      /* Dark text only on buttons with light cyan filled backgrounds */
      .encore-bright-accent-set button,
      [data-encore-id="buttonPrimary"],
      [class*="button"][class*="filled"],
      [class*="Button"][class*="filled"] {
        color: #0b0d13 !important;
      }
      CSSEOF
    '';
  };
in {
  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "miku-stars";
      src = mikuStarsTheme;
    };
    colorScheme = "miku-stars";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };
}
