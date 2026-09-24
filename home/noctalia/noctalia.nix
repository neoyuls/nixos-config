{
  pkgs,
  lib,
  ...
}: {
  stylix.targets.noctalia.enable = false;

  # noctalia picks its network backend once at startup; if NetworkManager isn't on
  # the bus yet it latches onto wpa_supplicant and the wifi widget stays blank
  systemd.user.services.noctalia.Service.ExecStartPre = let
    waitForNM = pkgs.writeShellScript "noctalia-wait-for-networkmanager" ''
      i=0
      while [ "$i" -lt 100 ]; do
        if ${pkgs.systemd}/bin/busctl --system status org.freedesktop.NetworkManager >/dev/null 2>&1; then
          exit 0
        fi
        ${pkgs.coreutils}/bin/sleep 0.1
        i=$((i + 1))
      done
      exit 0
    '';
  in "${waitForNM}";

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        font_family = lib.mkForce "JetBrains Mono";
        panel = {
          transparency_mode = "solid";
          borders = true;
        };
      };

      theme = {
        mode = "light";
        source = "custom";
        custom_palette = "Mine";
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/wallpapers";
        default.path = "~/Pictures/wallpapers/cdmx_jogorman.jpg";
      };

      bar.main = {
        position = "top";
        capsule = true;
        reserve_space = false;
        thickness = 30;
        margin_ends = 10;
        margin_edge = 8;
        radius = 12;
        start = ["launcher" "clock" "sysmon" "active_window" "media"];
        center = ["workspaces"];
        end = ["network" "battery" "bluetooth" "tray" "notifications" "volume" "screen-lock" "control-center"];
      };

      notification.background_opacity = 1.0;
      osd.background_opacity = 1.0;

      widget = {
        clock = {
          format = "{:%H:%M %a, %b %d}";
          vertical_format = "{:%H %M}";
        };
        workspaces = {
          label_source = "id";
          show_labels = true;
          hide_when_empty = false;
        };
        "control-center" = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          custom_image_colorize = true;
        };
        # 1-click lock: custom_button type, left click fires the `session lock`
        # IPC verb, which raises noctalia's own lock screen
        "screen-lock" = {
          type = "custom_button";
          glyph = "lock";
          tooltip = "Lock screen";
          actions = {left = "session lock";};
        };
      };
    };

    # cdmx-jogorman base16 palette mapped to Material Design color roles.
    # Polarity is light, so this is the `light` variant: surfaces are plaster
    # cream and on* colours are the warm charcoal ramp.
    customPalettes.Mine = {
      light = {
        mPrimary = "#0d7892"; # base0C mural teal (primary accent)
        mOnPrimary = "#f7f0e7"; # base00
        mSecondary = "#1a5b8c"; # base0D blueprint blue
        mOnSecondary = "#f7f0e7"; # base00
        mTertiary = "#6d4f76"; # base0E dusty plum
        mOnTertiary = "#f7f0e7"; # base00
        mError = "#a8321c"; # base08 brick red
        mOnError = "#f7f0e7"; # base00
        mSurface = "#f7f0e7"; # base00 plaster cream
        mOnSurface = "#2a2b26"; # base06 dark fg
        mSurfaceVariant = "#efe4d6"; # base01 raised surface
        mOnSurfaceVariant = "#3c3a34"; # base05 mid fg
        mOutline = "#968878"; # base03 dusty stone
        mShadow = "#968878"; # base03 (shadows read as stone, not paper)
        mHover = "#0d7892"; # base0C mural teal
        mOnHover = "#f7f0e7"; # base00
        terminal = {
          foreground = "#3c3a34"; # base05
          background = "#f7f0e7"; # base00
          selectionFg = "#181a17"; # base07
          selectionBg = "#e0d0bd"; # base02
          cursor = "#0d7892"; # base0C
          cursorText = "#f7f0e7"; # base00
          # light polarity: slot 0 is the darkest tone, slot 15 the background
          normal = {
            black = "#181a17"; # base07
            red = "#a8321c"; # base08
            green = "#2e6f4a"; # base0B
            yellow = "#8b681c"; # base0A
            blue = "#1a5b8c"; # base0D
            magenta = "#6d4f76"; # base0E
            cyan = "#0d7892"; # base0C
            white = "#968878"; # base03
          };
          bright = {
            black = "#6d6259"; # base04, readable bright-black
            red = "#a8321c"; # base08
            green = "#2e6f4a"; # base0B
            yellow = "#8b681c"; # base0A
            blue = "#1a5b8c"; # base0D
            magenta = "#6d4f76"; # base0E
            cyan = "#0d7892"; # base0C
            white = "#f7f0e7"; # base00
          };
        };
      };
    };
  };
}
