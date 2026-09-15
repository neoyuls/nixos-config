{lib, ...}: let
  # lain-rose palette: same values as ghostty.nix / kitty/cyberdream.conf;
  # tab colours from kitty/tabs.conf.
  bg = "#000000";
  fg = "#edbac3";
  cursor = "#e070c0";
  selection = "#36192a";
  tab = {
    activeBg = "#b840a0";
    activeFg = "#000000";
    inactiveBg = "#30131f";
    inactiveFg = "#e8a0a8";
  };

  bind = key: mods: action: {inherit key mods action;};
in {
  # Font, colours and keybinds are kept in sync with kitty and ghostty. The
  # stylix wezterm target is disabled in home.nix so it does not layer its own
  # font/colour scheme on top.
  programs.wezterm = {
    enable = true;

    # Rendered into ~/.config/wezterm/wezterm.lua by home-manager.
    settings = {
      # Appearance
      font = lib.generators.mkLuaInline ''wezterm.font("JetBrains Mono")'';
      font_size = 11;
      window_padding = {
        left = 10;
        right = 10;
        top = 10;
        bottom = 10;
      };
      window_background_opacity = 0.85;
      # Same intent as kitty background_blur / ghostty background-blur-radius:
      # compositor-side (ext-background-effect), so a no-op under niri for now.
      wayland_window_background_blur = true;
      window_decorations = "RESIZE"; # niri draws the borders (prefer-no-csd)

      colors = {
        background = bg;
        foreground = fg;
        cursor_bg = cursor;
        cursor_border = cursor;
        cursor_fg = bg;
        selection_bg = selection;
        selection_fg = fg;
        ansi = ["#1a0c14" "#e82050" "#b05c82" "#f0d090" "#a060d8" "#e070c0" "#f49ab0" "#c87888"];
        brights = ["#a85e74" "#e82050" "#b05c82" "#f0d090" "#a060d8" "#e070c0" "#f49ab0" "#faeaec"];
        split = selection; # kitty inactive_border_color
        tab_bar = {
          background = bg;
          active_tab = {
            bg_color = tab.activeBg;
            fg_color = tab.activeFg;
            intensity = "Bold";
          };
          inactive_tab = {
            bg_color = tab.inactiveBg;
            fg_color = tab.inactiveFg;
          };
          inactive_tab_hover = {
            bg_color = tab.inactiveBg;
            fg_color = fg;
          };
          new_tab = {
            bg_color = bg;
            fg_color = tab.inactiveFg;
          };
          new_tab_hover = {
            bg_color = bg;
            fg_color = fg;
          };
        };
      };

      # Behaviour
      scrollback_lines = 10000;
      audible_bell = "Disabled";
      window_close_confirmation = "NeverPrompt";
      hide_mouse_cursor_when_typing = true;
      check_for_updates = false; # nix manages the package

      # Tab bar: same look as kitty/tabs.conf (the rounded caps come from the
      # format-tab-title handler in extraConfig below).
      use_fancy_tab_bar = false;
      hide_tab_bar_if_only_one_tab = true;
      show_new_tab_button_in_tab_bar = false;
      tab_max_width = 40;

      # Keys: same bindings as ghostty.nix / kitty tabs.conf; wezterm's
      # defaults (ctrl+shift+c/v, ctrl+shift+f, ctrl+shift+p palette, ...)
      # stay active. Actions are the table form of wezterm.action.*.
      keys =
        [
          (bind "Enter" "CTRL|SHIFT" {SplitVertical.domain = "CurrentPaneDomain";})
          (bind "t" "CTRL" {SpawnTab = "CurrentPaneDomain";})
          (bind "w" "CTRL" {CloseCurrentPane.confirm = false;})

          (bind "h" "CTRL" {ActivatePaneDirection = "Left";})
          (bind "l" "CTRL" {ActivatePaneDirection = "Right";})
          (bind "k" "CTRL" {ActivatePaneDirection = "Up";})
          (bind "j" "CTRL" {ActivatePaneDirection = "Down";})

          (bind "PageUp" "CTRL|SHIFT" {MoveTabRelative = -1;})
          (bind "PageDown" "CTRL|SHIFT" {MoveTabRelative = 1;})
        ]
        ++ map (i: bind (toString i) "ALT" {ActivateTab = i - 1;}) (lib.range 1 9);
    };

    # The one part that has to be Lua: a callback drawing each tab as a
    # rounded pill "(index) title" like kitty/tabs.conf. Remove this block to
    # fall back to wezterm's plain rectangular tabs (colours above still apply).
    extraConfig = ''
      local left_cap = wezterm.nerdfonts.ple_left_half_circle_thick -- U+E0B6
      local right_cap = wezterm.nerdfonts.ple_right_half_circle_thick -- U+E0B4

      wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
        local tab_bg = tab.is_active and "${tab.activeBg}" or "${tab.inactiveBg}"
        local tab_fg = tab.is_active and "${tab.activeFg}" or "${tab.inactiveFg}"

        local title = tab.tab_title
        if not title or #title == 0 then
          title = tab.active_pane.title
        end
        local index = string.format(" (%d) ", tab.tab_index + 1)
        -- wezterm clips the whole formatted title at max_width; trim the title
        -- ourselves so the closing cap always survives.
        local reserved = wezterm.column_width(left_cap .. index .. " " .. right_cap .. " ")
        title = wezterm.truncate_right(title, max_width - reserved)

        return {
          { Background = { Color = "${bg}" } },
          { Foreground = { Color = tab_bg } },
          { Text = left_cap },
          { Background = { Color = tab_bg } },
          { Foreground = { Color = tab_fg } },
          { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
          { Text = index .. title .. " " },
          { Background = { Color = "${bg}" } },
          { Foreground = { Color = tab_bg } },
          { Text = right_cap .. " " },
        }
      end)
    '';
  };
}
