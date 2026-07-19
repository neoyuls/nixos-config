{lib, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = lib.mkForce "Jetbrains Mono";
      size = lib.mkForce 11;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      window_padding_width = 10;
      background_opacity = "0.85";
      background_blur = 5;
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "F7" = "layout_action rotate";
      "shift+up" = "move_window up";
      "shift+left" = "move_window left";
      "shift+right" = "move_window right";
      "shift+down" = "move_window down";
      "ctrl+H" = "neighboring_window left";
      "ctrl+L" = "neighboring_window right";
      "ctrl+K" = "neighboring_window up";
      "ctrl+J" = "neighboring_window down";
    };
    # cyberdream.conf is the static fallback; wal colors override at runtime
    extraConfig = builtins.readFile ./tabs.conf + "\n" + builtins.readFile ./cyberdream.conf + "\n# pywal dynamic colors\ninclude ~/.cache/wal/colors-kitty.conf\n";
  };
}
