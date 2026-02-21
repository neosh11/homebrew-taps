# AGENTS.md

Code guide for contributors and coding agents working in `homebrew-taps`.

## Purpose
- This repository maintains Homebrew tap formulae for Neosh MCP servers.
- Keep install behavior simple and predictable.
- This repository also owns cross-MCP platform ADRs (shared shell/data/discovery contracts).

## ADR rules
- ADRs live under `doc/adr/` and use incremental numeric prefixes (`0001-...`).
- Any change to shared shell/data/discovery architecture must update or supersede the relevant ADR.
- Current baseline architecture ADR:
  - `doc/adr/0001-shared-shell-data-discovery.md`

## GitHub interaction policy
- Prefer using a GitHub MCP server for GitHub interactions (releases, tags, assets, metadata) when available.
- Use GitHub MCP outputs as the source of truth before changing formula versions or release URLs.

## Release update rules
- Use versioned release URLs from source app repositories only.
- Do not use moving `latest` URLs with fixed checksums.
- For `visa-jobs-mcp`, update only when both macOS assets and `.sha256` files exist for the target tag:
  - `visa-jobs-mcp-vX.Y.Z-macos-arm64.tar.gz`
  - `visa-jobs-mcp-vX.Y.Z-macos-x86_64.tar.gz`
- If a newer tag exists but assets are missing, keep formula pinned to the latest fully published release.

## Formula checklist
1. Bump `version` in each changed formula.
2. Update architecture URLs and SHA256 values.
3. Keep install logic compatible with both onefile and onedir release layouts.
4. Run:
```bash
brew install --build-from-source ./Formula/<formula>.rb
brew test <formula>
```

## Commit hygiene
- Stage only relevant files.
- Avoid unrelated formatting churn.
- Keep README instructions aligned with formula behavior.
