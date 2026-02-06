# Mercator AI

Merkle-enhanced codebase mapping for AI agents. Maps codebases of any size using parallel subagents, with O(1) change detection and zero-token staleness prevention.

> Built upon [Bootoshi's Cartographer](https://github.com/kingbootoshi/cartographer), enhanced with Merkle tree change detection, post-commit hooks, and a map-first exploration protocol.

## What's Different from Cartographer?

| Feature | Cartographer | Mercator AI |
|---------|-------------|-------------|
| Codebase scanning | Token counting | Token counting + SHA-256 hashing |
| Change detection | `git log --since` | Merkle tree O(1) root hash comparison |
| Update mode | Re-scan entire codebase | `--diff` against manifest, only re-explore changed files |
| Staleness prevention | Manual re-run | Post-commit hook auto-refreshes manifest (zero tokens) |
| Manifest | None | `docs/.mercator.json` with full merkle tree |
| TLDR integration | None | Auto-invalidates cached summaries for changed files |
| Exploration protocol | None | Map-first protocol documentation for agents |
| Git dependency | Required for updates | Optional — hash-based diff works without git |

## Install

### Claude Code Plugin Registry

```bash
claude plugins install mercator-ai
```

### Manual (GitHub)

```bash
git clone https://github.com/shihwesley/mercator-ai.git ~/.claude/plugins/mercator-ai
```

### Dependencies

The scanner requires tiktoken. With UV (recommended), it's automatic:

```bash
uv run scan-codebase.py  # tiktoken auto-installed
```

Without UV:
```bash
pip install tiktoken
```

## Usage

### Map a codebase

```
/mercator-ai
```

Or say: "map this codebase", "create codebase map", "document the architecture"

This creates:
- `docs/CODEBASE_MAP.md` — Architecture documentation with diagrams, module guides, data flows
- `docs/.mercator.json` — Merkle manifest for change tracking

### Check for changes (O(1))

```bash
uv run scan-codebase.py . --diff docs/.mercator.json
```

Returns instantly: `has_changes: true/false` with lists of changed/added/removed files.

### Auto-refresh on commit

The post-commit hook (`hooks/mercator-auto-refresh.sh`) automatically:
1. Detects git commits
2. Runs `--diff` against the manifest
3. Refreshes hashes for changed files (~2s, zero tokens)
4. Invalidates TLDR cache entries (if present)
5. Flags structural changes that need a full `/mercator-ai` run

**Cost: ~2 seconds of Python. No API calls. No tokens.**

## How It Works

```
/mercator-ai invoked
        |
        v
+---------------------------------------+
|  1. Run scan-codebase.py              |
|     - Recursive file tree             |
|     - Token count + SHA-256 per file  |
|     - Merkle tree with root hash      |
|     - Respects .gitignore             |
+---------------------------------------+
        |
        v
+---------------------------------------+
|  2. Plan subagent assignments         |
|     - Group files by module           |
|     - Balance token budgets           |
|     - Skip unchanged modules (diff)   |
+---------------------------------------+
        |
        v
+---------------------------------------+
|  3. Spawn Sonnet subagents PARALLEL   |
|     - Each reads assigned files       |
|     - Analyzes purpose, dependencies  |
|     - Returns structured summary      |
+---------------------------------------+
        |
        v
+---------------------------------------+
|  4. Synthesize all reports            |
|     - Merge subagent outputs          |
|     - Build architecture diagram      |
|     - Create navigation guides        |
+---------------------------------------+
        |
        v
+---------------------------------------+
|  5. Write outputs                     |
|     - docs/CODEBASE_MAP.md            |
|     - docs/.mercator.json (manifest)  |
|     - Update CLAUDE.md with summary   |
+---------------------------------------+
        |
        v
+---------------------------------------+
|  6. Post-commit hook keeps it fresh   |
|     - Auto-refresh manifest on commit |
|     - Zero tokens, ~2 seconds         |
+---------------------------------------+
```

## Scanner CLI

```bash
# Full scan with merkle tree (JSON)
uv run scan-codebase.py .

# Human-readable tree with token counts
uv run scan-codebase.py . --format tree

# Tree with file hashes visible
uv run scan-codebase.py . --format tree --show-hash

# Just the merkle tree (for manifest storage)
uv run scan-codebase.py . --format merkle

# Compact: files sorted by token count
uv run scan-codebase.py . --format compact

# Diff against previous manifest
uv run scan-codebase.py . --diff docs/.mercator.json
```

## Map-First Exploration Protocol

See [docs/MAP_FIRST_PROTOCOL.md](docs/MAP_FIRST_PROTOCOL.md) for the full protocol.

**TL;DR:** Always read `docs/CODEBASE_MAP.md` before Glob/Grep. Use the manifest to skip unchanged files. Target specific files based on the map.

| Task | Blind Scan | Map-First |
|------|-----------|-----------|
| "Where is auth?" | ~15k tokens | ~2k tokens |
| "Understand API layer" | ~8k tokens | ~1.5k tokens |
| "Any changes?" | ~15k tokens | ~50 tokens |

## Merkle Tree

The `.mercator.json` manifest contains a hierarchical merkle tree:

```
root_hash: "a1b2c3d4e5f6"        <- O(1) "anything changed?"
├── src/: "f1e2d3c4b5a6"          <- O(1) "src/ changed?"
│   ├── api/: "..."               <- drill to changed module
│   │   ├── routes.ts: "..."      <- individual file hash
│   │   └── auth.ts: "..."
│   └── lib/: "..."
└── tests/: "..."
```

- **O(1) staleness check**: Compare root hash
- **O(log n) change localization**: Walk down tree to find changed modules
- **Works without git**: Pure hash-based comparison

## Output Structure

The generated `docs/CODEBASE_MAP.md` includes:

- **System Overview** — Mermaid architecture diagram
- **Directory Structure** — Annotated file tree
- **Module Guide** — Per-module documentation with purpose, exports, dependencies
- **Data Flow** — Mermaid sequence diagrams for key flows
- **Conventions** — Naming, patterns, style
- **Gotchas** — Non-obvious behaviors and warnings
- **Navigation Guide** — How to add features, modify systems

## Attribution

Mercator AI is built upon [Cartographer](https://github.com/kingbootoshi/cartographer) by [Bootoshi](https://github.com/kingbootoshi). See [ATTRIBUTION.md](ATTRIBUTION.md) for details on what came from the original and what was added.

## License

MIT — See [LICENSE](LICENSE) for dual copyright notice.
