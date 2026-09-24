{lib, ...}: let
  bg = "#f7f0e7";
  fg = "#3c3a34";
  cursor = "#0d7892";
  selection = "#e0d0bd";
  tab = {
    activeBg = "#0d7892";
    activeFg = "#f7f0e7";
    inactiveBg = "#efe4d6";
    inactiveFg = "#6d6259";
  };

  bind = key: mods: action: {inherit key mods action;};
in {
  programs.wezterm = {
    enable = true;

    settings = {
      font = lib.generators.mkLuaInline ''wezterm.font("JetBrains Mono")'';
      font_size = 11;
      window_padding = {
        left = 10;
        right = 10;
        top = 10;
        bottom = 10;
      };
      window_background_opacity = 0.85;
      wayland_window_background_blur = true;
      window_decorations = "RESIZE";
      default_cursor_style = "BlinkingUnderline";
      cursor_blink_ease_in = "Constant";
      cursor_blink_ease_out = "Constant";

      colors = {
        background = bg;
        foreground = fg;
        cursor_bg = cursor;
        cursor_border = cursor;
        cursor_fg = bg;
        selection_bg = selection;
        selection_fg = fg;
        # light polarity: slot 0 is the darkest tone and slot 15 the background
        ansi = ["#181a17" "#a8321c" "#2e6f4a" "#8b681c" "#1a5b8c" "#6d4f76" "#0d7892" "#968878"];
        brights = ["#6d6259" "#a8321c" "#2e6f4a" "#8b681c" "#1a5b8c" "#6d4f76" "#0d7892" "#f7f0e7"];
        split = selection;
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

      scrollback_lines = 10000;
      audible_bell = "Disabled";
      window_close_confirmation = "NeverPrompt";
      hide_mouse_cursor_when_typing = true;
      check_for_updates = false;

      use_fancy_tab_bar = false;
      hide_tab_bar_if_only_one_tab = true;
      show_new_tab_button_in_tab_bar = false;
      tab_max_width = 40;

      keys =
        [
          (bind "Enter" "CTRL|SHIFT" {SplitVertical.domain = "CurrentPaneDomain";})
          (bind "t" "CTRL" {SpawnTab = "CurrentPaneDomain";})
          (bind "w" "CTRL" {CloseCurrentPane.confirm = false;})

          # Terminals can't tell Ctrl+Backspace from Backspace, so send ^W
          # instead: backward-kill-word in zsh/readline, i_CTRL-W in neovim.
          (bind "Backspace" "CTRL" {
            SendKey = {
              key = "w";
              mods = "CTRL";
            };
          })

          (bind "h" "CTRL" {ActivatePaneDirection = "Left";})
          (bind "l" "CTRL" {ActivatePaneDirection = "Right";})
          (bind "k" "CTRL" {ActivatePaneDirection = "Up";})
          (bind "j" "CTRL" {ActivatePaneDirection = "Down";})

          (bind "PageUp" "CTRL|SHIFT" {MoveTabRelative = -1;})
          (bind "PageDown" "CTRL|SHIFT" {MoveTabRelative = 1;})
        ]
        ++ map (i: bind (toString i) "ALT" {ActivateTab = i - 1;}) (lib.range 1 9);
    };

    extraConfig = ''
      local left_cap = wezterm.nerdfonts.ple_left_half_circle_thick
      local right_cap = wezterm.nerdfonts.ple_right_half_circle_thick

      wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
        local tab_bg = tab.is_active and "${tab.activeBg}" or "${tab.inactiveBg}"
        local tab_fg = tab.is_active and "${tab.activeFg}" or "${tab.inactiveFg}"

        local title = tab.tab_title
        if not title or #title == 0 then
          title = tab.active_pane.title
        end
        local index = string.format(" (%d) ", tab.tab_index + 1)
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

      -- Remember the working directory of the focused pane and open new
      -- windows there (what ghostty's window-inherit-working-directory did).
      -- Tabs/splits already inherit it via CurrentPaneDomain. Every `wezterm`
      -- launch re-evaluates this file, so the value is used without a reload.
      local last_cwd_file = (os.getenv("XDG_STATE_HOME") or wezterm.home_dir .. "/.local/state")
        .. "/wezterm/last_cwd"

      local function read_last_cwd()
        local f = io.open(last_cwd_file, "r")
        if not f then
          return nil
        end
        local dir = f:read("*l")
        f:close()
        return dir
      end

      local function write_last_cwd(dir)
        local tmp = last_cwd_file .. ".tmp"
        local f = io.open(tmp, "w")
        if not f then
          wezterm.run_child_process({ "mkdir", "-p", last_cwd_file:match("(.*)/") })
          f = io.open(tmp, "w")
        end
        if f then
          f:write(dir, "\n")
          f:close()
          os.rename(tmp, last_cwd_file)
        end
      end

      local function is_dir(path)
        local f = io.open(path .. "/", "r")
        if not f then
          return false
        end
        f:close()
        return true
      end

      -- cwd of the pane's foreground process (OSC 7 or /proc); skip remote (ssh) ones
      local function local_cwd(pane)
        local url = pane:get_current_working_dir()
        if not url or not url.file_path or url.file_path == "" then
          return nil
        end
        local host = url.host
        if host and host ~= "" and host ~= "localhost" and host ~= wezterm.hostname() then
          return nil
        end
        return url.file_path
      end

      wezterm.on("update-status", function(window, pane)
        if not window:is_focused() then
          return
        end
        local cwd = local_cwd(pane)
        if cwd and cwd ~= read_last_cwd() then
          write_last_cwd(cwd)
        end
      end)

      local extra = {}
      local last_cwd = read_last_cwd()
      if last_cwd and last_cwd ~= "" and is_dir(last_cwd) then
        -- fresh GUI processes and `wezterm start -- prog`
        extra.default_cwd = last_cwd
        -- plain `wezterm` (Mod+Return) spawning a window into the running GUI
        extra.default_gui_startup_args = { "start", "--cwd", last_cwd }
      end
      return extra
    '';
  };
}
