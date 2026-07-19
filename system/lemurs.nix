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
          color = "#000000";
          show_border = true;
          border_color = "#7a4462";
        };
      };

      power_controls = {
        hint_margin = 2;
        base_entries = [
          {
            hint = "Shutdown";
            hint_color = "#a85e74";
            hint_modifiers = "";
            key = "F1";
            cmd = "systemctl poweroff -l";
          }
          {
            hint = "Reboot";
            hint_color = "#a85e74";
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
        toggle_hint_color = "#a85e74";
        toggle_hint_modifiers = "";
        include_tty_shell = false;
        remember = true;

        show_movers = true;
        mover_color = "#a85e74";
        mover_modifiers = "";
        mover_color_focused = "#fc9eb6";
        mover_modifiers_focused = "bold";
        left_mover = "<";
        right_mover = ">";
        mover_margin = 1;

        show_neighbours = true;
        neighbour_color = "#a85e74";
        neighbour_modifiers = "";
        neighbour_color_focused = "#fc9eb6";
        neighbour_modifiers_focused = "";
        neighbour_margin = 1;

        selected_color = "#d878a0";
        selected_modifiers = "underlined";
        selected_color_focused = "#fc9eb6";
        selected_modifiers_focused = "bold";

        max_display_length = 8;
        no_envs_text = "No environments...";
        no_envs_color = "#f4d8de";
        no_envs_modifiers = "";
        no_envs_color_focused = "#fc9eb6";
        no_envs_modifiers_focused = "";
      };

      username_field = {
        remember = true;
        style = {
          show_title = true;
          title = "Login";
          title_color = "#f4d8de";
          content_color = "#f4d8de";
          title_color_focused = "#fc9eb6";
          content_color_focused = "#fc9eb6";
          show_border = true;
          border_color = "#7a4462";
          border_color_focused = "#d878a0";
          use_max_width = true;
          max_width = 48;
        };
      };

      password_field = {
        content_replacement_character = "*";
        style = {
          show_title = true;
          title = "Password";
          title_color = "#f4d8de";
          content_color = "#f4d8de";
          title_color_focused = "#fc9eb6";
          content_color_focused = "#fc9eb6";
          show_border = true;
          border_color = "#7a4462";
          border_color_focused = "#d878a0";
          use_max_width = true;
          max_width = 48;
        };
      };
    };
  };
}
