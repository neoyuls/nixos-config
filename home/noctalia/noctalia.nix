{
  pkgs,
  lib,
  ...
}: {
  stylix.targets.noctalia.enable = false;
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
        mode = "dark";
        source = "custom";
        custom_palette = "Mine";
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/wallpapers";
        default.path = "~/Pictures/wallpapers/lain_wp_1.jpg";
      };

      bar.main = {
        position = "top";
        capsule = true;
        reserve_space = false;
        thickness = 30;
        margin_h = 10;
        margin_v = 8;
        radius = 12;
        start = ["launcher" "clock" "sysmon" "active_window" "media"];
        center = ["workspaces"];
        end = ["network" "battery" "bluetooth" "tray" "notifications" "volume" "control-center"];
      };

      notification.background_opacity = 1.0;
      osd.background_opacity = 1.0;

      widget = {
        clock = {
          format = "{:%H:%M %a, %b %d}";
          vertical_format = "{:%H %M}";
        };
        workspaces = {
          display = "id";
          hide_when_empty = false;
        };
        "control-center" = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          custom_image_colorize = true;
        };
      };
    };

    # lain-rose base16 palette mapped to Material Design color roles
    customPalettes.Mine = {
      dark = {
        mPrimary = "#a060d8"; # base0D lavender-violet
        mOnPrimary = "#000000"; # base00
        mSecondary = "#e070c0"; # base0E pink-magenta
        mOnSecondary = "#000000"; # base00
        mTertiary = "#f49ab0"; # base0C bright rose-pink
        mOnTertiary = "#000000"; # base00
        mError = "#e82050"; # base08 hot crimson
        mOnError = "#000000"; # base00
        mSurface = "#000000"; # base00 pure black
        mOnSurface = "#d488a0"; # base05 mid rose
        mSurfaceVariant = "#1a0c14"; # base01 very dark rose
        mOnSurfaceVariant = "#b87080"; # base04 dusty rose
        mOutline = "#965270"; # base03 readable wine
        mShadow = "#000000"; # base00
        mHover = "#f49ab0"; # base0C bright rose-pink
        mOnHover = "#000000"; # base00
        terminal = {
          foreground = "#d488a0"; # base05
          background = "#000000"; # base00
          selectionFg = "#000000"; # base00
          selectionBg = "#e070c0"; # base0E
          cursor = "#d488a0"; # base05
          cursorText = "#000000"; # base00
          normal = {
            black = "#000000"; # base00
            red = "#e82050"; # base08
            green = "#b05c82"; # base0B
            yellow = "#f0d090"; # base0A
            blue = "#a060d8"; # base0D
            magenta = "#e070c0"; # base0E
            cyan = "#f49ab0"; # base0C
            white = "#d488a0"; # base05
          };
          bright = {
            black = "#a85e74"; # muted rose, readable bright-black
            red = "#e82050"; # base08
            green = "#b05c82"; # base0B
            yellow = "#f0d090"; # base0A
            blue = "#a060d8"; # base0D
            magenta = "#e070c0"; # base0E
            cyan = "#f49ab0"; # base0C
            white = "#faeaec"; # base07
          };
        };
      };
    };
  };
}
