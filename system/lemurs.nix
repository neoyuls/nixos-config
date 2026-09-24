{
  config,
  lib,
  ...
}: {
  services.displayManager.lemurs = {
    enable = true;
    settings = {
      do_log = true;
      focus_behaviour = "default";

      background = {
        show_background = true;
        style = {
          color = "#0b0d13";
          show_border = true;
          border_color = "#3f6699";
        };
      };

      power_controls = {
        hint_margin = 2;
        base_entries = [
          {
            hint = "Shutdown";
            hint_color = "#507bb0";
            hint_modifiers = "";
            key = "F1";
            cmd = "systemctl poweroff -l";
          }
          {
            hint = "Reboot";
            hint_color = "#507bb0";
            hint_modifiers = "";
            key = "F2";
            cmd = "systemctl reboot -l";
          }
        ];
        entries = [];
      };

      environment_switcher = {
        switcher_visibility = "visible";
        toggle_hint = "Switcher %key%";
        toggle_hint_color = "#507bb0";
        toggle_hint_modifiers = "";
        include_tty_shell = false;
        remember = true;

        show_movers = true;
        mover_color = "#507bb0";
        mover_modifiers = "";
        mover_color_focused = "#8feff0";
        mover_modifiers_focused = "bold";
        left_mover = "<";
        right_mover = ">";
        mover_margin = 1;

        show_neighbours = true;
        neighbour_color = "#507bb0";
        neighbour_modifiers = "";
        neighbour_color_focused = "#8feff0";
        neighbour_modifiers_focused = "";
        neighbour_margin = 1;

        selected_color = "#6de3e5";
        selected_modifiers = "underlined";
        selected_color_focused = "#8feff0";
        selected_modifiers_focused = "bold";

        max_display_length = 8;
        no_envs_text = "No environments...";
        no_envs_color = "#cfe3f7";
        no_envs_modifiers = "";
        no_envs_color_focused = "#8feff0";
        no_envs_modifiers_focused = "";
      };

      username_field = {
        remember = true;
        style = {
          show_title = true;
          title = "Login";
          title_color = "#cfe3f7";
          content_color = "#cfe3f7";
          title_color_focused = "#8feff0";
          content_color_focused = "#8feff0";
          show_border = true;
          border_color = "#3f6699";
          border_color_focused = "#6de3e5";
          use_max_width = true;
          max_width = 48;
        };
      };

      password_field = {
        content_replacement_character = "*";
        style = {
          show_title = true;
          title = "Password";
          title_color = "#cfe3f7";
          content_color = "#cfe3f7";
          title_color_focused = "#8feff0";
          content_color_focused = "#8feff0";
          show_border = true;
          border_color = "#3f6699";
          border_color_focused = "#6de3e5";
          use_max_width = true;
          max_width = 48;
        };
      };
    };
  };
}
