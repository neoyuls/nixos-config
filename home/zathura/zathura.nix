{lib, ...}: {
  programs.zathura = {
    enable = true;

    # Force B&W recolor (overrides Stylix palette injection for readability with PDFs)
    options = {
      recolor-lightcolor = lib.mkForce "#000000";
      recolor-darkcolor = lib.mkForce "#ffffff";
      recolor-keephue = lib.mkForce false;
      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      statusbar-home-tilde = true;
      window-title-basename = true;
    };

    mappings = {
      # misc
      i = "recolor";
      # navigation
      "j" = "scroll down";
      "k" = "scroll up";
      "h" = "navigate previous"; # previous page
      "l" = "navigate next"; # next page
      # zoom
      "+" = "zoom in";
      "-" = "zoom out";
      "=" = "zoom fit";
    };
  };
}
