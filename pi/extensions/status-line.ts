/**
 * Status Line Extension
 *
 * Displays persistent status text in the footer showing turn progress,
 * model info, and context usage.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	let turnCount = 0;

	pi.on("session_start", async (_event, ctx) => {
		const model = ctx.model;
		const modelLabel = model ? `${model.provider}/${model.id}` : "no model";
		ctx.ui.setStatus("status-line", `[MODEL] ${modelLabel}`);
	});

	pi.on("turn_start", async (_event, ctx) => {
		turnCount++;
		const usage = ctx.getContextUsage();
		const tokens = usage ? `(${usage.tokens.toLocaleString()} tokens)` : "";
		ctx.ui.setStatus("status-line", `[RUN] Turn ${turnCount} ${tokens}`);
	});

	pi.on("turn_end", async (_event, ctx) => {
		const usage = ctx.getContextUsage();
		const tokens = usage ? `(${usage.tokens.toLocaleString()} tokens)` : "";
		ctx.ui.setStatus("status-line", `[DONE] Turn ${turnCount} ${tokens}`);
	});

	pi.on("model_select", async (event, ctx) => {
		const next = `${event.model.provider}/${event.model.id}`;
		ctx.ui.setStatus("status-line", `[MODEL] ${next}`);
	});
}
