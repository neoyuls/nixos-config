{pkgs, ...}: let
  config = builtins.toJSON {
    logo = {
      padding = {
        left = 2;
        right = 2;
      };
    };
    display = {separator = "  ";};
    modules = [
      {
        type = "title";
        color = {
          user = "38;2;240;128;144";
          at = "38;2;184;64;160";
          host = "38;2;232;160;168";
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
        keyColor = "38;2;240;128;144";
        color = "38;2;232;160;168";
      }
      {
        type = "host";
        key = " │ ▸ device  ";
        keyColor = "38;2;136;48;168";
        color = "38;2;232;160;168";
      }
      {
        type = "uptime";
        key = " │ ▸ uptime  ";
        keyColor = "38;2;232;160;168";
        color = "38;2;232;160;168";
      }
      {
        type = "packages";
        key = " │ ▸ pkgs    ";
        keyColor = "38;2;200;104;136";
        color = "38;2;232;160;168";
      }
      {
        type = "shell";
        key = " │ ▸ shell   ";
        keyColor = "38;2;200;104;136";
        color = "38;2;232;160;168";
      }
      {
        type = "terminal";
        key = " │ ▸ term    ";
        keyColor = "38;2;184;64;160";
        color = "38;2;232;160;168";
      }
      {
        type = "wm";
        key = " │ ▸ wm      ";
        keyColor = "38;2;184;64;160";
        color = "38;2;232;160;168";
      }
      {
        type = "custom";
        format = " ├── hardware ───────────────────";
      }
      {
        type = "cpu";
        key = " │ ▸ cpu     ";
        keyColor = "38;2;242;200;168";
        color = "38;2;232;160;168";
      }
      {
        type = "gpu";
        key = " │ ▸ gpu     ";
        keyColor = "38;2;232;32;80";
        color = "38;2;232;160;168";
      }
      {
        type = "memory";
        key = " │ ▸ mem     ";
        keyColor = "38;2;184;64;160";
        color = "38;2;232;160;168";
      }
      {
        type = "disk";
        key = " │ ▸ disk    ";
        keyColor = "38;2;242;200;168";
        color = "38;2;232;160;168";
      }
      {
        type = "battery";
        key = " │ ▸ battery ";
        keyColor = "38;2;200;104;136";
        color = "38;2;232;160;168";
      }
      {
        type = "custom";
        format = " ├── display ────────────────────";
      }
      {
        type = "display";
        key = " │ ▸ monitor ";
        keyColor = "38;2;136;48;168";
        color = "38;2;232;160;168";
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
  xdg.configFile."fastfetch/config.jsonc".text = config;
}
