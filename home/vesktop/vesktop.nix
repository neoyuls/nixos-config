{config, ...}: let
  c = config.lib.stylix.colors;
in {
  programs.vesktop = {
    enable = true;

    settings = {
      tray = true;
      minimizeToTray = false;
      checkUpdates = false;
      splashTheming = true;
      discordBranch = "stable";
      openLinksWithElectron = false;
      arRPC = false;
      transparent = true;
    };

    vencord.settings = {
      useQuickCss = true;
      transparent = true;
      frameless = false;
      autoUpdate = true;
      autoUpdateNotification = true;
      plugins = {
        CrashHandler.enabled = true;
        CommandsAPI.enabled = true;
        MessageAccessoriesAPI.enabled = true;
        UserSettingsAPI.enabled = true;
        WebKeybinds.enabled = true;
        WebScreenShareFixes.enabled = true;
        BadgeAPI.enabled = true;
      };
      notifications = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 50;
      };
    };

    vencord.extraQuickCss = ''
      /* Lain Rose — derived from Stylix base16 palette */

      .theme-dark,
      .theme-darker,
      .theme-midnight,
      .visual-refresh,
      .visual-refresh.theme-dark,
      .visual-refresh.theme-darker,
      .visual-refresh.theme-midnight {
        /* Visual Refresh tokens */
        --bg-base-primary:           #${c.base00}8C !important;
        --bg-base-secondary:         #${c.base01}99 !important;
        --bg-base-tertiary:          #${c.base02}99 !important;
        --bg-surface-raised:         #${c.base01}EB !important;
        --bg-surface-overlay:        #${c.base00}D9 !important;
        --bg-surface-overlay-tinted: #${c.base01}EB !important;
        --bg-overlay-app-frame:      transparent !important;
        --bg-overlay-chat:           transparent !important;
        --bg-overlay-floating:       #${c.base01}EB !important;
        --bg-overlay-1:              #${c.base02}99 !important;
        --bg-overlay-2:              #${c.base02}99 !important;
        --bg-overlay-3:              #${c.base01}EB !important;
        --bg-overlay-4:              #${c.base00}D9 !important;
        --bg-mod-faint:              #${c.base0E}0A !important;
        --bg-mod-subtle:             #${c.base0E}14 !important;
        --bg-mod-strong:             #${c.base0E}2E !important;
        --bg-mod-extra-strong:       #${c.base0E}4D !important;
        --bg-mod-faint-hover:        #${c.base0E}14 !important;
        --bg-mod-subtle-hover:       #${c.base0E}1F !important;
        --bg-mod-strong-hover:       #${c.base0E}38 !important;
        --bg-brand:                  #${c.base0E} !important;
        --bg-brand-tint-300:         #${c.base0C} !important;
        --bg-brand-tint-400:         #${c.base0E} !important;
        --bg-brand-tint-500:         #${c.base0E} !important;
        --bg-brand-tint-600:         #${c.base08} !important;
        --text-default:              #${c.base06} !important;
        --text-primary:              #${c.base07} !important;
        --text-secondary:            #${c.base06} !important;
        --text-tertiary:             #${c.base04} !important;
        --text-muted:                #${c.base04} !important;
        --text-link:                 #${c.base0D} !important;
        --text-brand:                #${c.base0E} !important;
        --text-danger:               #${c.base08} !important;
        --text-positive:             #${c.base0C} !important;
        --text-warning:              #${c.base0A} !important;
        --border-faint:              transparent !important;
        --border-subtle:             #${c.base03}D9 !important;
        --border-strong:             #${c.base03}D9 !important;
        --button-filled-brand-background:        #${c.base0E} !important;
        --button-filled-brand-background-hover:  #${c.base0C} !important;
        --button-filled-brand-text:              #${c.base00} !important;
        --button-outline-brand-text:             #${c.base0E} !important;
        --status-danger-background:  #${c.base08}1A !important;

        /* Legacy tokens */
        --background-primary:           #${c.base00}8C !important;
        --background-secondary:         #${c.base01}99 !important;
        --background-secondary-alt:     #${c.base02}99 !important;
        --background-tertiary:          #${c.base02}99 !important;
        --background-accent:            #${c.base0E} !important;
        --background-floating:          #${c.base01}EB !important;
        --background-message-hover:     #${c.base02}99 !important;
        --background-modifier-hover:    #${c.base0E}14 !important;
        --background-modifier-active:   #${c.base0E}26 !important;
        --background-modifier-selected: #${c.base0E}33 !important;
        --background-mentioned:         #${c.base0E}1A !important;
        --background-mentioned-hover:   #${c.base0E}26 !important;
        --background-mobile-primary:    #${c.base00}8C !important;
        --background-mobile-secondary:  #${c.base01}99 !important;
        --channeltextarea-background:   #${c.base02}99 !important;
        --activity-card-background:     #${c.base01}99 !important;
        --modal-background:             #${c.base00}D9 !important;
        --modal-footer-background:      #${c.base01}EB !important;
        --popover-background:           #${c.base01}EB !important;
        --header-primary:               #${c.base07} !important;
        --header-secondary:             #${c.base06} !important;
        --text-normal:                  #${c.base06} !important;
        --text-link-low-saturation:     #${c.base0D} !important;
        --interactive-normal:           #${c.base06} !important;
        --interactive-hover:            #${c.base07} !important;
        --interactive-active:           #${c.base07} !important;
        --interactive-muted:            #${c.base04} !important;
        --brand-experiment:             #${c.base0E} !important;
        --brand-experiment-300:         #${c.base0C} !important;
        --brand-experiment-400:         #${c.base0E} !important;
        --brand-experiment-500:         #${c.base0E} !important;
        --brand-experiment-600:         #${c.base08} !important;
        --brand-500:                    #${c.base0E} !important;
        --brand-560:                    #${c.base0E} !important;
        --scrollbar-thin-thumb:         #${c.base03}D9 !important;
        --scrollbar-thin-track:         transparent !important;
        --scrollbar-auto-thumb:         #${c.base03}D9 !important;
        --scrollbar-auto-track:         transparent !important;
        --input-background:             #${c.base02}99 !important;
      }

      /* Zero out hard-coded backgrounds so the transparent window shows through */
      html,
      body,
      #app-mount,
      .visual-refresh,
      .visual-refresh > div,
      [class*="appAsidePanelWrapper_"],
      [class*="notAppAsidePanel_"],
      [class*="app_"],
      [class^="app-"],
      [class*=" app-"],
      [class^="appMount"],
      [class*=" appMount"],
      [class^="layers"],
      [class*=" layers"],
      [class^="baseLayer"],
      [class*=" baseLayer"] {
        background: transparent !important;
        background-color: transparent !important;
      }

      .visual-refresh [class*="sidebarList_"],
      .visual-refresh [class*="sidebar_"],
      .visual-refresh [class*="chat_"],
      .visual-refresh [class*="chatContent_"],
      .visual-refresh [class*="panels_"],
      [class^="sidebar"],
      [class*=" sidebar"],
      [class^="panels"],
      [class*=" panels"],
      [class^="chat"],
      [class^="content"] {
        background-color: transparent !important;
      }

      .visual-refresh [class*="members_"],
      .visual-refresh [class*="membersWrap_"] {
        background-color: #${c.base01}99 !important;
      }

      [class^="guilds"],
      .visual-refresh [class*="guilds_"] {
        background-color: #${c.base00}8C !important;
      }
    '';
  };
}
