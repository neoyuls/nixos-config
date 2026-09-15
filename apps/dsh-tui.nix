{
  writeShellApplication,
  coreutils,
}:
# dsh-TUI under the cco bubblewrap sandbox ($HOME read-only, persisted dirs granted
# explicitly). cco's --add-dir swallows the non-flag args after it, so --command
# and "$@" must come after the last --add-dir.
writeShellApplication {
  name = "dsh-tui";
  runtimeInputs = [coreutils];
  text = ''
    if ! command -v cco >/dev/null 2>&1; then
      echo "dsh-tui: cco not found on PATH (expected ~/.local/bin/cco)" >&2
      exit 1
    fi

    # cco aborts on a nonexistent --add-dir
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
