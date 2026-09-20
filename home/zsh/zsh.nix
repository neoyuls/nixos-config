{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    shellAliases = {
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake 'path:${config.home.homeDirectory}/nixos-config#nixyuls' --impure";
      update = "sudo nix flake update --flake ${config.home.homeDirectory}/nixos-config";
      optimize = "nix-collect-garbage && nix-store --optimize";
      cc42 = "gcc -fsanitize=address,undefined -Wall -Wextra -Werror";
      disk = "df -h | grep nvme";

      # always run agents in a sandbox
      # dst = sandboxed wrapper (apps/dsh-tui.nix), raw-dsh = unsandboxed

      oco = "cco opencode";
      dst = "dsh-tui";
      raw-dsh = "dsh --profile dsh-tui";
      upload-albums = "rclone copy ~/Music/albums proton-drive:Music/albums --transfers=2 --no-update-modtime --protondrive-replace-existing-draft --retries=5 --low-level-retries=10";
      alex = "sudo alejandra";
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
    };
    oh-my-zsh = {
      enable = true;
      theme = "amuse";
      plugins = ["git" "colorize"];
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
        file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
    ];
    history = {
      size = 10000;
      save = 10000;
    };
    initContent = ''
      _zsh_autosuggest_strategy_truncated_history() {
        _zsh_autosuggest_strategy_history "$1"
        [[ ''${#REPLY} -gt $(( ''${#1} + 50 )) ]] && REPLY="''${REPLY:0:$(( ''${#1} + 50 ))}"
      }
      ZSH_AUTOSUGGEST_STRATEGY=(truncated_history)

      # Tab / Shift-Tab cycle through zsh-autocomplete's matches instead of inserting the top one
      bindkey '^I' menu-complete
      bindkey "$terminfo[kcbt]" reverse-menu-complete

      eval "$(micromamba shell hook --shell zsh | sed 's#.*basename.*mamba-wrapped.*#__exe_name=micromamba#')"
    '';
  };
}
