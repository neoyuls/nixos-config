{
  config,
  pkgs,
  lib,
  local,
  ...
}:
# Theming note: Stylix handles system-wide base16 colorscheme.
# ghostty, wezterm, spicetify, vesktop, firefox, and qgis use manually crafted themes
# that derive from the Stylix base16 palette. If you change the colorscheme,
# update these files too:
#   - home/ghostty/ghostty.nix
#   - home/wezterm/wezterm.nix
#   - home/spicetify/spicetify.nix
#   - home/vesktop/themes/lain-rose.css
#   - home/firefox/userContent.css
#   - home/qgis/qgis.qss
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
    "yazi/theme.toml".source = ./yazi/theme.toml;
    "yazi/lain-rose.tmTheme".source = ../assets/lain-rose.tmTheme;
  };

  home.file."Pictures/wallpapers".source = ../assets/wallpapers;

  home.activation.createNiriColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    COLORS_FILE="$HOME/.config/niri/colors.kdl"
    if [[ ! -f "$COLORS_FILE" ]]; then
        mkdir -p "$HOME/.config/niri"
        printf 'layout {\n    focus-ring {\n        active-color "#d878a0"\n        inactive-color "#4a2638"\n    }\n}\n' \
            > "$COLORS_FILE"
    fi
  '';

  home.packages = with pkgs; [
    (pkgs.callPackage ../apps/depthmapx.nix {})
    # element-desktop
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
