{
  config,
  pkgs,
  local,
  ...
}:
# Theming note: Stylix handles the system-wide base16 colorscheme
# (assets/miku-stars.yaml, derived from the Sleeping Miku Animated Firefox
# theme and assets/wallpapers/miku-stars.jpg).
# Several programs use manually crafted themes instead of the Stylix target,
# all derived from that base16 palette. If you change the colorscheme, update
# these files too:
#   - home/ghostty/ghostty.nix
#   - home/wezterm/wezterm.nix
#   - home/spicetify/spicetify.nix
#   - home/vesktop/vesktop.nix
#   - home/firefox/firefox.nix
#   - home/qgis/qgis.nix
#   - home/fastfetch/fastfetch.nix
#   - home/neovim/neovim.nix (cyberdream color override)
#   - home/noctalia/noctalia.nix (customPalettes.Mine)
#   - home/yazi/theme.toml (assets/miku-stars.tmTheme)
#   - home/niri/config.kdl + the niri/colors.kdl below
#   - system/lemurs.nix
# (home/pi/pi.nix regenerates itself from config.lib.stylix.colors)
{
  imports = [
    # ./element/element.nix
    ./mime/mime.nix
    ./noctalia/noctalia.nix
    ./neovim/neovim.nix
    ./ghostty/ghostty.nix
    ./fastfetch/fastfetch.nix
    ./firefox/firefox.nix
    ./vesktop/vesktop.nix
    ./spicetify/spicetify.nix
    ./zsh/zsh.nix
    ./qgis/qgis.nix
    ./pi/pi.nix
    ./wezterm/wezterm.nix
    ./zathura/zathura.nix
  ];

  home.username = local.username;
  home.homeDirectory = "/home/${local.username}";

  home.stateVersion = "25.11";

  home.sessionVariables = {
    MAMBA_ROOT_PREFIX = "${config.home.homeDirectory}/.local/share/mamba";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  xdg.configFile = {
    # templated so @homeDir@ is substituted; niri does not shell-expand include/spawn args
    "niri/config.kdl".text =
      builtins.replaceStrings ["@homeDir@"] [config.home.homeDirectory]
      (builtins.readFile ./niri/config.kdl);
    # generated from the palette so the focus-ring colours always track the
    # scheme (the config.kdl borders below are updated by hand)
    "niri/colors.kdl".text = ''
      layout {
          focus-ring {
              active-color "#${config.lib.stylix.colors.base0C}"
              inactive-color "#${config.lib.stylix.colors.base02}"
          }
      }
    '';
    "yazi/theme.toml".source = ./yazi/theme.toml;
    "yazi/miku-stars.tmTheme".source = ../assets/miku-stars.tmTheme;
  };

  home.file."Pictures/wallpapers".source = ../assets/wallpapers;

  home.packages = with pkgs; [
    pi-coding-agent
    (pkgs.callPackage ../apps/depthmapx.nix {})
    # element-desktop
    bk
    localsend
    kdePackages.okular
    geckodriver
    zathura
    xwayland-satellite
    bubblewrap
    grim
    slurp
    wl-clipboard
    nwg-displays
    bolt-launcher
    runelite
    texliveFull
    ryubing
  ];
  home.pointerCursor.enable = true;
  home.pointerCursor = {
    name = "ComixCursors-Opaque-Black";
    package = pkgs.comixcursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  stylix.targets.ghostty.enable = false;
  stylix.targets.wezterm.enable = false;
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = local.gitName;
      user.email = local.email;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.dircolors = {
    enable = true;
    extraConfig = ''
      OTHER_WRITABLE          01;33
      STICKY_OTHER_WRITABLE   01;33;04
    '';
  };
}
