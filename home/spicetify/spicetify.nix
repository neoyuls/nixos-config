{
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  c = config.lib.stylix.colors;

  cdmxTheme = pkgs.stdenvNoCC.mkDerivation {
    name = "cdmx-jogorman";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out

      cat > $out/color.ini << EOF
      [cdmx-jogorman]
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
        --spice-subtext: #181a17 !important;
        --encore-secondary-text: #181a17 !important;
        --text-subdued: #181a17 !important;
        --text-base: #2a2b26 !important;
      }

      /* Force readable text color directly in Friend Activity */
      .Root__right-sidebar * {
        color: #3c3a34 !important;
      }
      .Root__right-sidebar strong,
      .Root__right-sidebar [class*="name"],
      .Root__right-sidebar [class*="Name"],
      .Root__right-sidebar [class*="title"],
      .Root__right-sidebar [class*="Title"] {
        color: #181a17 !important;
      }

      .Root__main-view {
        background: #f7f0e7 !important;
      }

      .Root__nav-bar,
      .Root__top-bar {
        background: #efe4d6 !important;
      }

      /* Now-playing bar */
      .Root__now-playing-bar {
        background: #efe4d6 !important;
        border-top: 1px solid rgba(13, 120, 146, 0.3) !important;
      }

      /* Top bar */
      .Root__top-bar header {
        background: #efe4d6 !important;
      }

      /* Left sidebar nav */
      .Root__nav-bar > nav,
      .Root__nav-bar > .nav-alt {
        background: #efe4d6 !important;
      }

      /* Cards */
      .main-card-card {
        background: #e0d0bd !important;
        transition: background 0.2s ease !important;
      }

      .main-card-card:hover {
        background: #d5c3ad !important;
      }

      /* Context menus / dropdowns */
      .main-contextMenu-menu,
      .x-filterBox-filterInput {
        background: #e0d0bd !important;
        border: 1px solid rgba(13, 120, 146, 0.25) !important;
      }

      /* Player control icons — darken against the light now-playing bar */
      .Root__now-playing-bar button svg,
      .Root__now-playing-bar button path {
        fill: #181a17 !important;
      }
      .Root__now-playing-bar button {
        opacity: 1 !important;
      }
      /* Icon-only buttons (shuffle, download, invite, ...) draw their SVGs
         with currentColor on light backgrounds — keep them dark */
      button {
        color: #2a2b26 !important;
      }
      /* Light text only on buttons with dark teal filled backgrounds */
      .encore-bright-accent-set button,
      [data-encore-id="buttonPrimary"],
      [class*="button"][class*="filled"],
      [class*="Button"][class*="filled"] {
        color: #f7f0e7 !important;
      }
      CSSEOF
    '';
  };
in {
  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "cdmx-jogorman";
      src = cdmxTheme;
    };
    colorScheme = "cdmx-jogorman";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };
}
