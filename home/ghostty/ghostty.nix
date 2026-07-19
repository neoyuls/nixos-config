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
      background-blur-radius = 20;
      scrollback-limit = 10000;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;

      background = "#000000";
      foreground = "#edbac3";
      cursor-color = "#e070c0";
      cursor-text = "#000000";
      selection-background = "#36192a";
      selection-foreground = "#edbac3";

      palette = [
        "0=#1a0c14"
        "1=#e82050"
        "2=#b05c82"
        "3=#f0d090"
        "4=#a060d8"
        "5=#e070c0"
        "6=#f49ab0"
        "7=#c87888"
        "8=#a85e74"
        "9=#e82050"
        "10=#b05c82"
        "11=#f0d090"
        "12=#a060d8"
        "13=#e070c0"
        "14=#f49ab0"
        "15=#faeaec"
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
