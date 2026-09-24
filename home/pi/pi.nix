{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
# Pi themes are plain JSON read from ~/.pi/agent/themes/, and Stylix has no pi
# target, so the theme is generated here from the Stylix base16 palette.
#
# Also wires in the extensions/skills from amosblomqvist/pi-config (pinned as the
# `pi-config` flake input). Those are linked as *individual files* into otherwise
# real directories rather than as whole symlinked trees, because pi auto-discovers
# ~/.pi/agent/extensions/*/index.ts and ~/.pi/agent/skills/*/SKILL.md while
# several of them must write beside themselves: prompt-snippets mkdirs a snippets
# dir, pdf-reader creates <SKILL_DIR>/.venv, analyze-sessions keeps caches.
#
# Deliberately NOT wired here: settings.json and pi-cc-extensions.json. pi
# rewrites those at runtime (lastChangelogVersion, /settings, setDefaultModel,
# `pi install`), so managing them from Nix would turn them into read-only store
# symlinks and silently break that persistence -- the same failure mode as
# vesktop's settings.json.
#
# The theme is activated by assets/pi_custom_header.ts, which selects "stylix"
# on session_start; setTheme persists through the mutable settings.json, so it
# is a one-time write. Selecting a different theme with /settings still works,
# but the extension re-selects "stylix" on the next start.
let
  # Palette comes from the system Stylix config (system/default.nix ->
  # stylix.base16Scheme; currently assets/miku-stars.yaml). Nothing below
  # hardcodes a colour, so changing the scheme or the Stylix wallpaper
  # regenerates this theme on the next rebuild -- no edit needed here.
  c = config.lib.stylix.colors;

  # --- colour helpers --------------------------------------------------------
  # Nix has no hex integer literals, so parse the base16 strings through TOML.
  toInt = v: (builtins.fromTOML "v = 0x${v}").v;
  pad2 = n: let
    # lib.toHexString emits uppercase; keep the file lowercase like the rest of
    # the repo's generated themes.
    s = lib.toLower (lib.toHexString n);
  in
    if builtins.stringLength s == 1
    then "0${s}"
    else s;
  chan = mask: divisor: v: builtins.div (builtins.bitAnd v mask) divisor;
  mkHex = r: g: b: "#" + pad2 r + pad2 g + pad2 b;
  # base16 has no tint slots, but pi renders tool state as a background colour.
  # Mix bg -> accent in sRGB so pending/success/error stay visually distinct
  # instead of collapsing into one flat panel colour.
  blend = base: tint: weight: let
    bi = toInt base;
    ti = toInt tint;
    mix = ch: builtins.floor ((ch bi) * (1.0 - weight) + (ch ti) * weight + 0.5);
    chR = chan 16711680 65536;
    chG = chan 65280 256;
    chB = chan 255 1;
  in
    mkHex (mix chR) (mix chG) (mix chB);

  # base16 semantic slots. Names are pi-facing (referenced from `colors` below),
  # so they describe intent rather than the raw base0X index.
  vars = {
    bg0 = "#${c.base00}"; # near-black navy, transcript background
    bg1 = "#${c.base01}"; # theme toolbar, user message / tool panel background
    bg2 = "#${c.base02}"; # selection, raised surface
    bg3 = "#${c.base03}"; # starry blue, comments/muted borders
    fg0 = "#${c.base04}"; # dim blue, secondary text
    fg1 = "#${c.base05}"; # mid blue, default foreground
    fg2 = "#${c.base06}"; # light blue
    fg3 = "#${c.base07}"; # near-white

    red = "#${c.base08}"; # Miku pink
    orange = "#${c.base09}"; # warm star glow
    yellow = "#${c.base0A}"; # star gold
    green = "#${c.base0B}"; # mint green (base16 "green" slot)
    cyan = "#${c.base0C}"; # Miku cyan, primary accent
    blue = "#${c.base0D}"; # starry blue
    magenta = "#${c.base0E}"; # swirl violet
    brown = "#${c.base0F}"; # muted mauve (unused, kept for completeness)

    toolPendingBg = blend c.base01 c.base0D 0.14;
    toolSuccessBg = blend c.base01 c.base0B 0.22;
    toolErrorBg = blend c.base01 c.base08 0.22;
  };

  theme = {
    "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    # Stable name: it must not change when the palette changes, because
    # settings.json refers to the theme by name and is hand-managed.
    name = "stylix";
    inherit vars;
    colors = {
      # Core UI (13)
      accent = "cyan";
      border = "blue";
      borderAccent = "cyan";
      borderMuted = "bg2";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "fg0";
      dim = "bg3";
      text = ""; # terminal default; the terminal is Stylix-themed too
      thinkingText = "fg0";
      scrollbarTrack = "bg2";
      scrollbarThumb = "fg0";

      # Backgrounds & content (13)
      selectedBg = "bg2";
      searchMatchBg = "bg2";
      searchMatchText = "fg3";
      userMessageBg = "bg1";
      userMessageText = "";
      customMessageBg = "bg2";
      customMessageText = "";
      customMessageLabel = "magenta";
      toolPendingBg = "toolPendingBg";
      toolSuccessBg = "toolSuccessBg";
      toolErrorBg = "toolErrorBg";
      toolTitle = "fg2";
      toolOutput = "fg1";

      # Markdown (10)
      mdHeading = "yellow";
      mdLink = "cyan";
      mdLinkUrl = "bg3";
      mdCode = "cyan";
      mdCodeBlock = "fg1";
      mdCodeBlockBorder = "bg3";
      mdQuote = "fg0";
      mdQuoteBorder = "bg3";
      mdHr = "bg3";
      mdListBullet = "cyan";

      # Tool diffs (3)
      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "bg3";

      # Syntax highlighting (9)
      syntaxComment = "bg3";
      syntaxKeyword = "magenta";
      syntaxFunction = "blue";
      syntaxVariable = "fg1";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "cyan";
      syntaxOperator = "fg1";
      syntaxPunctuation = "fg0";

      # Thinking level borders (7): subtle -> prominent ramp
      thinkingOff = "bg2";
      thinkingMinimal = "bg3";
      thinkingLow = "fg0";
      thinkingMedium = "fg1";
      thinkingHigh = "blue";
      thinkingXhigh = "magenta";
      thinkingMax = "red";

      # Bash mode (1)
      bashMode = "orange";
    };
    # /export HTML uses raw hex: it is a separate section from `colors` and is
    # documented with literals, so do not assume vars resolve here.
    export = {
      pageBg = "#${c.base00}";
      cardBg = "#${c.base01}";
      infoBg = "#${c.base02}";
    };
  };

  # amosblomqvist/pi-config, pinned by flake.lock.
  piConfig = inputs.pi-config;

  # Repo-relative paths, mirrored under ~/.pi/agent. Single-file extensions plus
  # the individual files of the dir-shaped ones, so every parent directory stays
  # writable for the extension/skill that needs it.
  vendored = [
    # extensions with no npm dependencies (bash-guard/browser/web-fetch are
    # omitted: they need node_modules, which a read-only store symlink can't have)
    #
    # extensions/custom-header.ts is deliberately absent: the local, themed copy
    # in assets/ is linked over it below instead of pi-config's built-in header.
    "extensions/ask-user-question.ts"
    "extensions/prompt-snippets/index.ts"
    "extensions/prompt-snippets/snippets/ask-questions.md"
    "extensions/prompt-snippets/snippets/delegate-exploration.md"
    "extensions/prompt-snippets/snippets/diagnose-report.md"
    "extensions/prompt-snippets/snippets/orchestrator-mode.md"
    "extensions/prompt-snippets/snippets/session-kickoff.md"
    "extensions/prompt-snippets/snippets/verify-not-assume.md"
    # skills (markdown + stdlib python; no npm)
    "skills/analyze-sessions/SKILL.md"
    "skills/analyze-sessions/scripts/cost.py"
    "skills/analyze-sessions/scripts/prompts.py"
    "skills/analyze-sessions/scripts/search.py"
    "skills/analyze-sessions/scripts/sessions.py"
    "skills/analyze-sessions/scripts/show_session.py"
    "skills/pdf-reader/SKILL.md"
    "skills/pdf-reader/requirements.txt"
    "skills/pdf-reader/scripts/pdf_extract.py"
    "skills/pdf-reader/scripts/pdf_info.py"
    "skills/pdf-reader/scripts/pdf_render.py"
    "skills/pdf-reader/scripts/pdf_search.py"
    "skills/web-debug/SKILL.md"
    "skills/youtube-transcript/SKILL.md"
    "skills/youtube-transcript/fetch_transcript.py"
  ];

  vendoredFiles = lib.listToAttrs (map (rel: {
      name = ".pi/agent/${rel}";
      value.source = "${piConfig}/${rel}";
    })
    vendored);
in {
  # pi-mesh-extension stores its state (session identities, ledger, transcripts,
  # policy) in <cwd>/.mesh unless MESH_STATE_DIR overrides it. Point it at one
  # global dir so project directories stay clean -- this also makes the mesh
  # alias stable across projects instead of per-directory.
  home.sessionVariables.MESH_STATE_DIR = "${config.home.homeDirectory}/.local/state/mesh";

  # ~/.pi/agent is not an XDG directory, so this is home.file, not xdg.configFile.
  # A store symlink is fine for the theme: loadThemesFromDir() stats symlinked
  # entries when scanning ~/.pi/agent/themes/.
  home.file =
    vendoredFiles
    // {
      ".pi/agent/themes/stylix.json".source =
        (pkgs.formats.json {}).generate "pi-theme-stylix.json" theme;
      # Local custom header (assets/pi_custom_header.ts): the pi wordmark in a
      # theme-token accent ramp, plus the command that restores the built-in one.
      # Name must stay custom-header.ts so pi discovers it as an extension.
      # Two levels up: this file is home/pi/pi.nix, assets/ is at the repo root.
      ".pi/agent/extensions/custom-header.ts".source = ../../assets/pi_custom_header.ts;
    };
}
