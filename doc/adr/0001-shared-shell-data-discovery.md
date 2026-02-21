# ADR 0001: Shared Local Data Layer, Shell UI, and Service Discovery

- Status: Proposed
- Date: 2026-02-21
- Decision Type: Architecture

## Context

`good-mcps` is moving from a pure Homebrew tap role into a platform role that can host shared local UX and settings across multiple MCP servers.

We need to support:

1. One shared local data layer so all MCPs use the same database.
2. Logical isolation ("sub-databases") per MCP so each product can evolve independently.
3. One shared shell UI, while each MCP can ship and own its frontend from a separate repository.
4. Local service discovery so the shell can discover currently running MCP instances and their capabilities.
5. Strong extensibility and compatibility over time.

## Decision

Adopt a local platform model with these contracts:

1. A single local SQLite "platform database" for shared/core data.
2. Per-MCP logical sub-databases implemented as namespace-scoped tables by default, with an optional attached SQLite file per MCP for high-volume domains.
3. A singleton local shell UI process that provides shared navigation, identity, settings, and extension mounting.
4. A file-based discovery registry (with heartbeat + TTL) that running MCP servers write to, and the shell reads from.
5. Versioned extension and discovery manifests to allow independent release cadence across MCP repositories.

## Data Layer Contract

### Storage locations (cross-platform)

Base directory: `os.UserConfigDir()/good-mcps`

- macOS: `$HOME/Library/Application Support/good-mcps`
- Linux: `$HOME/.config/good-mcps`
- Windows: `%AppData%\\good-mcps`

### Database files

- Core DB: `data/platform.db`
- Optional MCP DBs: `data/extensions/<mcp-id>.db`

This preserves "same database" at the platform layer while allowing per-MCP data growth through attached files when needed.

### Core schema boundaries

Core DB owns shared tables only:

- `mcp_registry` (instance identity + current heartbeat state)
- `mcp_extensions` (extension manifests and compatibility metadata)
- `settings_global` (shell-level settings)
- `settings_mcp` (per-MCP settings records)
- `migration_history` (schema and data migration tracking)
- `audit_events` (optional operational trail)

Each MCP owns either:

- Namespace tables in `platform.db` named `mcp_<id>__*`, or
- Its attached DB (`<mcp-id>.db`) with full ownership of tables inside that file.

### Concurrency + reliability

- SQLite mode: WAL.
- Busy timeout enabled.
- Cross-process lock file around migration execution.
- No MCP is allowed to mutate another MCP's namespace or attached DB.

## Shell UI Contract

The shell is a reusable host with shared UX primitives:

- Header/navigation across all discovered MCPs.
- Shared settings page with per-MCP scoped settings panels.
- Standardized status surfaces (connected/disconnected, heartbeat age, errors).
- Secure host bridge for extension-to-host communication.

Individual MCP frontends live in their own repositories and are loaded by manifest.

### Extension manifest (versioned)

Each MCP provides a manifest with at least:

- `manifest_version`
- `mcp_id`
- `display_name`
- `frontend_entry` (local path or local URL served by MCP)
- `settings_schema_version`
- `required_host_api`
- `capabilities` (declared UI/tool features)

The shell must reject extensions with incompatible `manifest_version` or `required_host_api`.

## Service Discovery Contract

Use file-based local discovery for portability and simplicity.

### Discovery path

`os.UserConfigDir()/good-mcps/discovery/instances`

Each running MCP writes one JSON descriptor:

`<mcp-id>__<instance-id>.json`

Descriptor fields:

- `mcp_id`
- `instance_id`
- `version`
- `pid`
- `started_at`
- `last_heartbeat_at`
- `transport` (for example `stdio`, `http`)
- `health`
- `manifest_ref` (path/URL to extension manifest)
- `data_namespace` (or attached DB reference)

### Liveness model

- MCP heartbeat update interval: 5-15 seconds.
- Shell considers instance stale after 30 seconds without heartbeat.
- Shell removes stale instance from active UI list without deleting files immediately.
- MCP removes its descriptor on graceful shutdown.

This avoids mDNS/network complexity and works consistently on macOS/Linux/Windows.

## Extensibility Rules

1. Every contract is versioned (`manifest_version`, discovery descriptor version, host API version).
2. Backward-compatible additions are additive only.
3. Breaking changes require a new major contract version and compatibility window.
4. Shell must degrade gracefully when an MCP extension is unavailable or incompatible.
5. MCP runtime capability declarations must be treated as source of truth, not hard-coded in shell.

## Alternatives Considered

### A) Separate DB per MCP only

Rejected: weakens shared settings/querying and cross-MCP operational views.

### B) Central daemon + RPC-only data access

Deferred: stronger control but higher operational complexity for first rollout.

### C) mDNS/network discovery

Rejected for local-first use case: less reliable under corporate/VPN/firewall environments and unnecessary for same-machine workflows.

## Rollout Plan

1. Phase 1: introduce core `platform.db`, discovery folder, and manifest schema.
2. Phase 2: migrate one MCP (pilot) to shell-hosted settings and discovery registration.
3. Phase 3: enable optional attached DB per MCP for high-volume data domains.
4. Phase 4: enforce compatibility gates and publish extension SDK docs/templates.

## Consequences

Positive:

- Consistent local UX and shared settings across MCPs.
- Clear separation of shared platform responsibilities and per-MCP ownership.
- Scales to many MCPs without forcing a monolith.

Tradeoffs:

- Additional contract governance overhead.
- Shell host must maintain compatibility layers.
- Migration tooling is required for long-lived schema evolution.
