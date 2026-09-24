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

      background = "#0b0d13";
      foreground = "#cfe3f7";
      cursor-color = "#6de3e5";
      cursor-text = "#0b0d13";
      selection-background = "#1e2c47";
      selection-foreground = "#cfe3f7";

      palette = [
        "0=#0b0d13"
        "1=#ff4f8b"
        "2=#6fd6a8"
        "3=#f7d774"
        "4=#5aa9f0"
        "5=#b18bd8"
        "6=#6de3e5"
        "7=#a8c8e8"
        "8=#507bb0"
        "9=#ff4f8b"
        "10=#6fd6a8"
        "11=#f7d774"
        "12=#5aa9f0"
        "13=#b18bd8"
        "14=#6de3e5"
        "15=#eef6ff"
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
