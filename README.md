# homebrew-taps

Homebrew tap for Neosh MCP servers.

## Install

```bash
brew tap neosh11/taps
brew install neosh11/taps/visa-jobs-mcp
```

## MCP Formula Namespace

Formula files are organized under `Formula/mcp/`.

Install commands stay flat by formula name:
- `brew install neosh11/taps/visa-jobs-mcp`
- `brew install neosh11/taps/freelancer-mcp`

## Available formulae

- `visa-jobs-mcp` (current)

`freelancer-mcp` formula is generated/updated automatically by
`freelancer-mcp` release workflow once tag releases are published.

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

When updating formulae:
1. Verify release assets exist for required architectures.
2. Fetch checksums from corresponding `.sha256` files or release digest metadata.
3. Update `Formula/mcp/<formula>.rb` (`version`, URLs, SHA256s).
4. Commit and push this tap repo.
