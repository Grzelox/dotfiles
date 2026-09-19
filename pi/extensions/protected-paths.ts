/**
 * Protected Paths Extension
 *
 * Blocks write and edit operations to protected paths.
 * Useful for preventing accidental modifications to sensitive files.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const protectedPaths = [
		".env",
		".env.local",
		".env.production",
		".envrc",
		".git/",
		"node_modules/",
		".ssh/",
		".aws/",
		"secrets/",
		"*.key",
		"*.pem",
		"id_rsa",
		"id_ed25519",
	];

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "write" && event.toolName !== "edit") {
			return undefined;
		}

		const path = event.input.path as string;
		const isProtected = protectedPaths.some((p) => {
			if (p.startsWith("*")) {
				// Glob-like matching for patterns like *.key
				const suffix = p.slice(1);
				return path.endsWith(suffix);
			}
			return path.includes(p);
		});

		if (isProtected) {
			if (ctx.hasUI) {
				ctx.ui.notify(`Blocked write to protected path: ${path}`, "warning");
			}
			return { block: true, reason: `Path "${path}" is protected` };
		}

		return undefined;
	});
}
