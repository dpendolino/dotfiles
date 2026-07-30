import { $ } from "bun";

interface GitleaksFinding {
  RuleID: string;
  Description: string;
  Match: string;
  Secret: string;
  File: string;
  StartLine: number;
  EndLine: number;
}

export default async function () {
  return {
    "tool.execute.before": async (
      input: { tool: string; args: Record<string, unknown> },
      output: { args: Record<string, unknown> },
    ) => {
      const fileTools = new Set(["write", "edit", "write_file"]);
      if (!fileTools.has(input.tool)) return;

      const filePath = output.args.filePath as string | undefined;
      if (!filePath || typeof filePath !== "string") return;

      let result;
      try {
        result = await $`gitleaks detect --source ${filePath} --format json --no-git 2>&1`
          .nothrow()
          .quiet();
      } catch {
        return;
      }

      const stdout = result.text().trim();
      if (result.exitCode === 0 || !stdout) return;

      let findings: GitleaksFinding[];
      try {
        findings = JSON.parse(stdout);
        if (!Array.isArray(findings)) return;
      } catch {
        return;
      }

      if (findings.length === 0) return;

      const summary = findings
        .slice(0, 5)
        .map((f) => `  \u2022 ${f.RuleID}: ${f.Match || f.Description || f.Secret}`)
        .join("\n");

      throw new Error(
        [
          `gitleaks blocked write to ${filePath}: ${findings.length} secret(s) detected`,
          summary,
          findings.length > 5
            ? `  ... and ${findings.length - 5} more`
            : "",
          "Run `gitleaks detect --source <path> --format json --no-git` locally for full report.",
        ]
          .filter(Boolean)
          .join("\n"),
      );
    },
  };
}
