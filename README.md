# homebrew-good-mcps

Homebrew tap for Neosh MCP servers.

## Install

```bash
brew tap neosh11/good-mcps
brew install neosh11/good-mcps/visa-jobs-mcp
```

For now, the legacy tap also remains supported:

```bash
brew tap neosh11/visa-jobs-mcp
brew install neosh11/visa-jobs-mcp/visa-jobs-mcp
```

## Available formulae

- `visa-jobs-mcp`

After install:

```bash
visa-jobs-mcp --version
codex mcp add visa-jobs-mcp --env VISA_JOB_SITES=linkedin -- visa-jobs-mcp
```

## Upgrade

```bash
brew upgrade neosh11/good-mcps/visa-jobs-mcp
```

## Maintainers

When updating `visa-jobs-mcp`:
1. Verify assets exist for both architectures:
   - `visa-jobs-mcp-vX.Y.Z-macos-arm64.tar.gz`
   - `visa-jobs-mcp-vX.Y.Z-macos-x86_64.tar.gz`
2. Fetch checksums from corresponding `.sha256` files.
3. Update `Formula/visa-jobs-mcp.rb` (`version`, URLs, SHA256s).
4. Commit and push this tap repo.
