/**
 * Self-Improve Extension
 *
 * Meta-commands for managing and improving your pi installation.
 */

import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const CONFIG_DIR = join(homedir(), ".pi", "agent");

export default function (pi: ExtensionAPI) {
	// /pi-status — show installation health
	pi.registerCommand("pi-status", {
		description: "Show pi configuration status",
		handler: async (_args, ctx) => {
			const model = ctx.model;
			const usage = ctx.getContextUsage();
			const entries = ctx.sessionManager.getEntries().length;

			const lines = [
				"[STATUS] Pi Status",
				`  Model: ${model ? `${model.provider}/${model.id}` : "none"}`,
				`  Reasoning: ${ctx.thinkingLevel}`,
				`  Session entries: ${entries}`,
				`  Context: ${usage ? `${usage.tokens.toLocaleString()} tokens` : "unknown"}`,
				`  Idle: ${ctx.isIdle() ? "yes" : "no"}`,
			];

			if (ctx.hasUI) {
				for (const line of lines) {
					ctx.ui.notify(line, "info");
				}
			}
		},
	});

	// /pi-reload — quick alias for reloading
	pi.registerCommand("pi-reload", {
		description: "Reload all extensions, skills, prompts, and themes",
		handler: async (_args, ctx) => {
			await ctx.reload();
			ctx.ui.notify("Pi reloaded", "info");
		},
	});

	// /pi-extensions — list installed extensions
	pi.registerCommand("pi-extensions", {
		description: "List installed global extensions",
		handler: async (_args, ctx) => {
			const { execSync } = await import("node:child_process");
			try {
				const result = execSync(`ls -1 "${join(CONFIG_DIR, "extensions")}" 2>/dev/null || echo "No extensions installed"`, {
					encoding: "utf8",
				});
				ctx.ui.notify("Extensions:\n" + result, "info");
			} catch {
				ctx.ui.notify("Could not list extensions", "error");
			}
		},
	});
}
