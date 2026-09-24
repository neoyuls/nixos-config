{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;

  # fastfetch wants ANSI truecolor escapes ("38;2;R;G;B"), not hex, so build
  # them from the Stylix RGB channels. Previously these were literal decimal
  # triples, which silently went stale on every colourscheme change.
  rgb = slot: let
    r = c."${slot}-rgb-r";
    g = c."${slot}-rgb-g";
    b = c."${slot}-rgb-b";
  in "38;2;${r};${g};${b}";

  fastfetchConfig = builtins.toJSON {
    logo = {
      padding = {
        top = 2;
        bottom = 2;
        left = 2;
        right = 2;
      };
    };
    display = {separator = "  ";};
    modules = [
      {
        type = "title";
        color = {
          user = rgb "base0C";
          at = rgb "base0D";
          host = rgb "base05";
        };
      }
      {
        type = "custom";
        format = " │";
      }
      {
        type = "custom";
        format = " ├── system ─────────────────────";
      }
      {
        type = "os";
        key = " │ ▸ os      ";
        keyColor = rgb "base0C";
        color = rgb "base05";
      }
      {
        type = "host";
        key = " │ ▸ device  ";
        keyColor = rgb "base0E";
        color = rgb "base05";
      }
      {
        type = "uptime";
        key = " │ ▸ uptime  ";
        keyColor = rgb "base05";
        color = rgb "base05";
      }
      {
        type = "packages";
        key = " │ ▸ pkgs    ";
        keyColor = rgb "base04";
        color = rgb "base05";
      }
      {
        type = "shell";
        key = " │ ▸ shell   ";
        keyColor = rgb "base04";
        color = rgb "base05";
      }
      {
        type = "terminal";
        key = " │ ▸ term    ";
        keyColor = rgb "base0D";
        color = rgb "base05";
      }
      {
        type = "wm";
        key = " │ ▸ wm      ";
        keyColor = rgb "base0D";
        color = rgb "base05";
      }
      {
        type = "custom";
        format = " ├── hardware ───────────────────";
      }
      {
        type = "cpu";
        key = " │ ▸ cpu     ";
        keyColor = rgb "base0A";
        color = rgb "base05";
      }
      {
        type = "gpu";
        key = " │ ▸ gpu     ";
        keyColor = rgb "base08";
        color = rgb "base05";
      }
      {
        type = "memory";
        key = " │ ▸ mem     ";
        keyColor = rgb "base0D";
        color = rgb "base05";
      }
      {
        type = "disk";
        key = " │ ▸ disk    ";
        keyColor = rgb "base0A";
        color = rgb "base05";
      }
      {
        type = "battery";
        key = " │ ▸ battery ";
        keyColor = rgb "base04";
        color = rgb "base05";
      }
      {
        type = "custom";
        format = " ├── display ────────────────────";
      }
      {
        type = "display";
        key = " │ ▸ monitor ";
        keyColor = rgb "base0E";
        color = rgb "base05";
      }
      {
        type = "custom";
        format = " │";
      }
      {
        type = "custom";
        format = " └─────────────────────────────────";
      }
    ];
  };
in {
  home.packages = [pkgs.fastfetch];
  xdg.configFile."fastfetch/config.jsonc".text = fastfetchConfig;
}
