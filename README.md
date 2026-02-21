# homebrew-taps

Homebrew tap for Neosh MCP servers.

## Install

```bash
brew tap neosh11/taps
brew install neosh11/taps/visa-jobs-mcp
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
brew upgrade neosh11/taps/visa-jobs-mcp
```

## Maintainers

When updating `visa-jobs-mcp`:
1. Verify assets exist for both architectures:
   - `visa-jobs-mcp-vX.Y.Z-macos-arm64.tar.gz`
   - `visa-jobs-mcp-vX.Y.Z-macos-x86_64.tar.gz`
2. Fetch checksums from corresponding `.sha256` files.
3. Update `Formula/visa-jobs-mcp.rb` (`version`, URLs, SHA256s).
4. Commit and push this tap repo.
