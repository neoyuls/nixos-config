/**
 * Custom Header Extension
 *
 * Replaces the built-in startup header with the pi wordmark and a version line.
 * Managed by home/pi/pi.nix, which links this file to
 * ~/.pi/agent/extensions/custom-header.ts and generates the system theme.
 *
 * Theming: every colour here is a semantic token of the *active* pi theme, so
 * the header follows theme changes automatically. The system theme ("stylix",
 * generated from the Stylix base16 palette in home/pi/pi.nix) maps the logo
 * ramp to the wallpaper's Miku cyan -> starry blue -> swirl violet. Keep using
 * tokens rather than hex so the header survives a colourscheme change.
 *
 * Usage: edit this file and run /reload in pi.
 * To restore the built-in header: run /builtin-header, or delete the symlinked
 * file and /reload.
 */

import type { ExtensionAPI, Theme } from "@mariozechner/pi-coding-agent";
import { VERSION, keyHint, rawKeyHint } from "@mariozechner/pi-coding-agent";

/** System theme generated from config.lib.stylix.colors by home/pi/pi.nix. */
const SYSTEM_THEME = "stylix";

// ── Logo ────────────────────────────────────────────────
// The pi wordmark, one entry per terminal row.
const LOGO_ART = [
	"   ███████████████████████████╗  ",
	"   ╚══██████╔════════██████╔══╝  ",
	"      ██████║        ██████║     ",
	"      ██████║        ██████║     ",
	"      ██████║        ██████║     ",
	"      ██████║        ██████║     ",
	"      ██████║        ██████║     ",
	"      ██████║        ██████║     ",
	"   ████████████╗  ████████████╗  ",
	"   ╚═══════════╝  ╚═══════════╝  ",
];

/**
 * Logo colour ramp, top row -> bottom row. Under the system theme these resolve
 * to cyan -> starry blue -> violet; any other theme just remaps the same slots.
 */
const LOGO_RAMP = ["accent", "border", "customMessageLabel"] as const;

/** Spread the ramp evenly across `total` rows and return the row's token. */
function rampColor(index: number, total: number): (typeof LOGO_RAMP)[number] {
	if (total <= 1) return LOGO_RAMP[0];
	return LOGO_RAMP[Math.round((index / (total - 1)) * (LOGO_RAMP.length - 1))]!;
}

/**
 * Build the header text. This is what you customize.
 *   - The pi wordmark in the theme's accent ramp
 *   - App name + version
 */
function buildHeader(theme: Theme): string {
	const ascii_art_2 = LOGO_ART.map((line, row) =>
		theme.bold(theme.fg(rampColor(row, LOGO_ART.length), line)),
	).join("\n");

	const logo =
		"\n" + ascii_art_2 + "\n\n" +
		theme.bold(theme.fg("accent", "pi")) +
		theme.fg("dim", ` v${VERSION}`);

	// ── Keybinding hints ─────────────────────────────────
	// Each entry is one line. Remove, reorder, or add your own.
	// Use rawKeyHint("key", "description") for app-level shortcuts.
	// Use keyHint("editorAction", "description") for editor shortcuts.
	const hints = [
		rawKeyHint("escape", "to interrupt"),
		rawKeyHint("ctrl+c", "to clear"),
		rawKeyHint("ctrl+c twice", "to exit"),
		rawKeyHint("ctrl+d", "to exit (empty)"),
		rawKeyHint("ctrl+z", "to suspend"),
		keyHint("deleteToLineEnd", "to delete to end"),
		rawKeyHint("shift+tab", "to cycle thinking level"),
		rawKeyHint("ctrl+p/shift+ctrl+p", "to cycle models"),
		rawKeyHint("ctrl+l", "to select model"),
		rawKeyHint("ctrl+o", "to expand tools"),
		rawKeyHint("ctrl+t", "to expand thinking"),
		rawKeyHint("ctrl+g", "for external editor"),
		rawKeyHint("/", "for commands"),
		rawKeyHint("!", "to run bash"),
		rawKeyHint("!!", "to run bash (no context)"),
		rawKeyHint("alt+enter", "to queue follow-up"),
		rawKeyHint("alt+up", "to edit all queued messages"),
		rawKeyHint(process.platform === "win32" ? "alt+v" : "ctrl+v", "to paste image"),
		rawKeyHint("drop files", "to attach"),
	];

	//return `${logo}\n${hints.join("\n")}`;
	return logo
}



export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (!ctx.hasUI) return;

		// Select the generated system theme so the header (and the rest of the
		// TUI) matches the Stylix palette. setTheme persists via the mutable
		// ~/.pi/agent/settings.json, so this is a one-time write in practice.
		if (ctx.ui.theme.name !== SYSTEM_THEME && ctx.ui.getTheme(SYSTEM_THEME)) {
			ctx.ui.setTheme(SYSTEM_THEME);
		}

		ctx.ui.setHeader((_tui, theme) => ({
			render(_width: number): string[] {
				return buildHeader(theme).split("\n");
			},
			invalidate() {},
		}));
	});

	// Command to restore the built-in header
	pi.registerCommand("builtin-header", {
		description: "Restore the built-in startup header",
		handler: async (_args, ctx) => {
			ctx.ui.setHeader(undefined);
			ctx.ui.notify("Built-in header restored", "info");
		},
	});
}
