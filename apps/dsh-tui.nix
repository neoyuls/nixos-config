{
  writeShellApplication,
  coreutils,
}:
# Runs dsh-TUI under cco, the same bubblewrap sandbox used for the other agents.
# cco keeps $HOME read-only, so every directory dsh and dsh-TUI persist to has to
# be granted explicitly; $PWD and ~/.npm are already writable by default.
#
# Argument order is load-bearing: cco's --add-dir greedily swallows the non-flag
# arguments that follow it, so --command and the user's own arguments must come
# after the last --add-dir or they get parsed as directory paths.
writeShellApplication {
  name = "dsh-tui";
  runtimeInputs = [coreutils];
  text = ''
    if ! command -v cco >/dev/null 2>&1; then
      echo "dsh-tui: cco not found on PATH (expected ~/.local/bin/cco)" >&2
      exit 1
    fi

    # add_rw_path refuses a directory that does not exist and that refusal aborts
    # cco, so create each one before granting it. Harmless once they exist.
    for dir in \
      "$HOME/.dsh" \
      "$HOME/.dsh-tui" \
      "$HOME/.local/share/pnpm" \
      "$HOME/.cache/pnpm"; do
      mkdir -p "$dir"
    done

    exec cco \
      --add-dir "$HOME/.dsh" \
      --add-dir "$HOME/.dsh-tui" \
      --add-dir "$HOME/.local/share/pnpm" \
      --add-dir "$HOME/.cache/pnpm" \
      --command "dsh --profile dsh-tui" \
      "$@"
  '';
}
