{pkgs, ...}: {
  stylix.targets.firefox.profileNames = ["yuls"];

  # "Sleeping Miku Animated" (slubaru, AMO) vendored so the theme survives a
  # fresh profile. The AMO id is stable; activeThemeID below selects it.
  home.file.".mozilla/firefox/yuls/extensions/sleeping-miku@example.com.xpi".source = ./sleeping-miku.xpi;

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.yuls = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.tabs.inTitlebar" = 1;

        # middle-click drag to autoscroll; paste is disabled since it would
        # take over middle-click in the content area
        "general.autoScroll" = true;
        "middlemouse.paste" = false;
        "middlemouse.contentLoadURL" = false;

        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        "browser.in-content.dark-mode" = true;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "devtools.theme" = "dark";
        # the Sleeping Miku Animated theme (vendored above); without this the
        # generated user.js keeps forcing compact-dark back on every restart
        "extensions.activeThemeID" = "sleeping-miku@example.com";
        # enable profile-scope sideloaded add-ons (the theme xpi placed by HM)
        "extensions.autoDisableScopes" = 0;
        "extensions.lastAppVersion" = "";
        "widget.content.allow-gtk-dark-theme" = true;
        "widget.content.gtk-high-contrast.enabled" = false;

        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "privacy.partition.serviceWorkers" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.letterboxing" = false;
        "privacy.resistFingerprinting.exemptedDomains" = "";
        "privacy.fingerprintingProtection" = true;
        # +AllTargets includes the canvas *blocking* targets, which break canvas readback
        # outside user input (striped pasted images on WhatsApp Web); drop those three
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-CanvasImageExtractionPrompt,-CanvasExtractionBeforeUserInputIsBlocked,-CanvasExtractionFromThirdPartiesIsBlocked";
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "network.cookie.cookieBehavior" = 5;
        "network.cookie.sameSite.noneRequiresSecure" = true;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;
        "network.IDN_show_punycode" = true;

        "network.trr.mode" = 3;
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_first" = true;
        "security.ssl.require_safe_negotiation" = true;
        "security.tls.enable_0rtt_data" = false;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;
        "security.pki.crlite_mode" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.mixed_content.block_display_content" = true;

        "media.peerconnection.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

        "extensions.pocket.enabled" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.screenshots.disabled" = true;

        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;
        "signon.rememberSignons" = false;

        # search: local SearXNG is the only engine (see the search block below).
        # Suggestions stay off; "keyword.enabled" is what makes non-URL input in
        # the address bar fall through to the default engine.
        "keyword.enabled" = true;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.groupLabels.enabled" = false;

        "browser.formfill.enable" = false;
        "browser.cache.disk.enable" = false;

        "browser.contentblocking.category" = "strict";

        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";

        "geo.enabled" = false;
        "browser.search.region" = "US";
        "browser.search.geoSpecificDefaults" = false;
        "intl.accept_languages" = "en-US, en";

        "beacon.enabled" = false;
        "browser.send_pings" = false;
        "dom.battery.enabled" = false;
        "device.sensors.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;

        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.aboutConfig.showWarning" = false;
        "browser.disableResetPrompt" = true;

        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google4.gethashURL" = "";

        "app.update.background.scheduling.enabled" = false;
        "browser.search.update" = false;
        "extensions.getAddons.cache.enabled" = false;
        "extensions.systemAddon.update.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "browser.discovery.enabled" = false;

        "browser.pagethumbnails.capturing_disabled" = true;
        "browser.sessionstore.privacy_level" = 2;
        "browser.helperApps.deleteTempFileOnExit" = true;

        # sanitize on shutdown but keep cookies/sessions so logins survive
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.offlineApps" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown.siteSettings" = false;
        "privacy.clearOnShutdown_v2.cache" = true;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "privacy.clearOnShutdown_v2.siteSettings" = false;
        "network.cookie.lifetimePolicy" = 0;

        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.default.camera" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.xr" = 2;

        "pdfjs.enableScripting" = false;

        "network.http.referer.hideOnionSource" = true;

        "media.autoplay.default" = 5;
        "media.autoplay.blocking_policy" = 2;

        # DRM left ENABLED — Spotify Web Premium and similar need Widevine.
        "media.eme.enabled" = true;
        "media.gmp-widevinecdm.enabled" = true;

        "identity.fxaccounts.enabled" = false;
        "identity.fxaccounts.toolbar.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.uitour.url" = "";

        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.addons.featureGate" = false;
        "browser.urlbar.mdn.featureGate" = false;
        "browser.urlbar.pocket.featureGate" = false;
        "browser.urlbar.weather.featureGate" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.recentsearches.featureGate" = false;

        "browser.places.speculativeConnect.enabled" = false;
        "browser.search.serpEventTelemetryCategorization.enabled" = false;
        "browser.contentanalysis.enabled" = false;

        "dom.security.sanitizer.enabled" = true;
      };
      # local SearXNG instance (see system/default.nix). `force` is required to
      # replace the search.json.mozlz4 this profile already has; the generated
      # file is the version-12 format Firefox 156 reads, and HM hashes the
      # default engine id exactly the way SearchSettings.sys.mjs validates it.
      search = {
        engines.searxng-local = {
          name = "SearXNG (local)";
          urls = [
            {
              template = "http://127.0.0.1:8888/search";
              params = [{ name = "q"; value = "{searchTerms}"; }];
            }
          ];
          icon = "${pkgs.searxng}/share/static/themes/simple/img/favicon.png";
          definedAliases = ["@s" "@searxng"];
        };
        default = "searxng-local";
        privateDefault = "searxng-local";
        force = true;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    DEFAULT_BROWSER = "firefox";
  };
}
