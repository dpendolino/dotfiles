import { $ } from "bun";

interface DippyResponse {
  hookSpecificOutput?: {
    permissionDecision: string;
    permissionDecisionReason: string;
  };
}

const bashTools = new Set(["bash", "Bash"]);

export default async function () {
  return {
    "tool.execute.before": async (
      input: { tool: string; args: Record<string, unknown> },
      output: { args: Record<string, unknown> },
    ) => {
      if (!bashTools.has(input.tool)) return;

      const command = output.args.command as string | undefined;
      if (!command || typeof command !== "string") return;

      const cwd =
        (output.args.workdir as string | undefined) ||
        (output.args.cwd as string | undefined) ||
        process.cwd();

      const payload = JSON.stringify({
        tool_name: "Bash",
        tool_input: { command, cwd },
      });

      // Run dippy for permission check. If dippy isn't installed or fails,
      // allow the command through rather than breaking all bash usage.
      let result;
      try {
        result = await $`dippy`.stdin(payload).nothrow().quiet();
      } catch {
        // dippy binary not found or failed to spawn — allow command
        return;
      }

      const stdout = result.text().trim();
      if (!stdout) return;

      let response: DippyResponse;
      try {
        response = JSON.parse(stdout);
      } catch {
        return;
      }

      const decision = response.hookSpecificOutput?.permissionDecision;
      if (!decision || decision === "allow") return;

      const reason =
        response.hookSpecificOutput?.permissionDecisionReason ||
        "command not approved";

      throw new Error(
        `dippy blocked bash command:\n  Command: ${command}\n  Reason: ${reason}`,
      );
    },
  };
}
