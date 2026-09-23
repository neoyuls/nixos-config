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
        mode = "dark";
        source = "custom";
        custom_palette = "Mine";
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/wallpapers";
        default.path = "~/Pictures/wallpapers/miku-stars.jpg";
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
          label_source = "id";
          show_labels = true;
          hide_when_empty = false;
        };
        "control-center" = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          custom_image_colorize = true;
        };
      };
    };

    # miku-stars base16 palette mapped to Material Design color roles
    customPalettes.Mine = {
      dark = {
        mPrimary = "#6de3e5"; # base0C Miku cyan
        mOnPrimary = "#0b0d13"; # base00
        mSecondary = "#5aa9f0"; # base0D starry blue
        mOnSecondary = "#0b0d13"; # base00
        mTertiary = "#b18bd8"; # base0E swirl violet
        mOnTertiary = "#0b0d13"; # base00
        mError = "#ff4f8b"; # base08 Miku pink
        mOnError = "#0b0d13"; # base00
        mSurface = "#0b0d13"; # base00 near-black navy
        mOnSurface = "#cfe3f7"; # base06 light fg
        mSurfaceVariant = "#141b2b"; # base01 theme toolbar
        mOnSurfaceVariant = "#a8c8e8"; # base05 mid fg
        mOutline = "#3f6699"; # base03 starry blue
        mShadow = "#0b0d13"; # base00
        mHover = "#6de3e5"; # base0C Miku cyan
        mOnHover = "#0b0d13"; # base00
        terminal = {
          foreground = "#cfe3f7"; # base06
          background = "#0b0d13"; # base00
          selectionFg = "#0b0d13"; # base00
          selectionBg = "#5aa9f0"; # base0D
          cursor = "#6de3e5"; # base0C
          cursorText = "#0b0d13"; # base00
          normal = {
            black = "#0b0d13"; # base00
            red = "#ff4f8b"; # base08
            green = "#6fd6a8"; # base0B
            yellow = "#f7d774"; # base0A
            blue = "#5aa9f0"; # base0D
            magenta = "#b18bd8"; # base0E
            cyan = "#6de3e5"; # base0C
            white = "#a8c8e8"; # base05
          };
          bright = {
            black = "#507bb0"; # base04, readable bright-black
            red = "#ff4f8b"; # base08
            green = "#6fd6a8"; # base0B
            yellow = "#f7d774"; # base0A
            blue = "#5aa9f0"; # base0D
            magenta = "#b18bd8"; # base0E
            cyan = "#6de3e5"; # base0C
            white = "#eef6ff"; # base07
          };
        };
      };
    };
  };
}
