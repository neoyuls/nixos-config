{pkgs, ...}: let
  config = builtins.toJSON {
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
          user = "38;2;109;227;229";
          at = "38;2;90;169;240";
          host = "38;2;168;200;232";
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
        keyColor = "38;2;109;227;229";
        color = "38;2;168;200;232";
      }
      {
        type = "host";
        key = " │ ▸ device  ";
        keyColor = "38;2;177;139;216";
        color = "38;2;168;200;232";
      }
      {
        type = "uptime";
        key = " │ ▸ uptime  ";
        keyColor = "38;2;168;200;232";
        color = "38;2;168;200;232";
      }
      {
        type = "packages";
        key = " │ ▸ pkgs    ";
        keyColor = "38;2;80;123;176";
        color = "38;2;168;200;232";
      }
      {
        type = "shell";
        key = " │ ▸ shell   ";
        keyColor = "38;2;80;123;176";
        color = "38;2;168;200;232";
      }
      {
        type = "terminal";
        key = " │ ▸ term    ";
        keyColor = "38;2;90;169;240";
        color = "38;2;168;200;232";
      }
      {
        type = "wm";
        key = " │ ▸ wm      ";
        keyColor = "38;2;90;169;240";
        color = "38;2;168;200;232";
      }
      {
        type = "custom";
        format = " ├── hardware ───────────────────";
      }
      {
        type = "cpu";
        key = " │ ▸ cpu     ";
        keyColor = "38;2;247;215;116";
        color = "38;2;168;200;232";
      }
      {
        type = "gpu";
        key = " │ ▸ gpu     ";
        keyColor = "38;2;255;79;139";
        color = "38;2;168;200;232";
      }
      {
        type = "memory";
        key = " │ ▸ mem     ";
        keyColor = "38;2;90;169;240";
        color = "38;2;168;200;232";
      }
      {
        type = "disk";
        key = " │ ▸ disk    ";
        keyColor = "38;2;247;215;116";
        color = "38;2;168;200;232";
      }
      {
        type = "battery";
        key = " │ ▸ battery ";
        keyColor = "38;2;80;123;176";
        color = "38;2;168;200;232";
      }
      {
        type = "custom";
        format = " ├── display ────────────────────";
      }
      {
        type = "display";
        key = " │ ▸ monitor ";
        keyColor = "38;2;177;139;216";
        color = "38;2;168;200;232";
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
