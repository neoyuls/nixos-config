{lib, ...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrains Mono";
      font-size = 11;
      window-padding-x = 10;
      window-padding-y = 10;
      window-padding-balance = true;
      background-opacity = 0.85;
      background-blur-radius = 50;
      scrollback-limit = 10000;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;

      background = "#f7f0e7";
      foreground = "#3c3a34";
      cursor-color = "#0d7892";
      cursor-text = "#f7f0e7";
      selection-background = "#e0d0bd";
      selection-foreground = "#181a17";

      # ANSI ramp runs light -> dark (polarity is light), so slot 0 is the
      # darkest tone and slot 15 is the background:
      #   0 black base07, 8 bright-black base04, 7 white base03, 15 base00
      palette = [
        "0=#181a17"
        "1=#a8321c"
        "2=#2e6f4a"
        "3=#8b681c"
        "4=#1a5b8c"
        "5=#6d4f76"
        "6=#0d7892"
        "7=#968878"
        "8=#6d6259"
        "9=#a8321c"
        "10=#2e6f4a"
        "11=#8b681c"
        "12=#1a5b8c"
        "13=#6d4f76"
        "14=#0d7892"
        "15=#f7f0e7"
      ];

      keybind = [
        "ctrl+shift+enter=new_split:down"
        "ctrl+t=new_tab"
        "ctrl+w=close_surface"
        "alt+one=goto_tab:1"
        "alt+two=goto_tab:2"
        "alt+three=goto_tab:3"
        "alt+four=goto_tab:4"
        "alt+five=goto_tab:5"
        "alt+six=goto_tab:6"
        "alt+seven=goto_tab:7"
        "alt+eight=goto_tab:8"
        "alt+nine=goto_tab:9"
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
        "ctrl+k=goto_split:up"
        "ctrl+j=goto_split:down"
        "ctrl+shift+page_up=move_tab:-1"
        "ctrl+shift+page_down=move_tab:1"
      ];
    };
  };
}
