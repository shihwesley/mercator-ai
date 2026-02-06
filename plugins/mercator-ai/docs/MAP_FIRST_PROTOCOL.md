# Map-First Exploration Protocol

**MANDATORY for all codebase analysis:** Before exploring any project, agents MUST use the map-first protocol below. Blind scanning (Glob/Grep without reading the map) wastes tokens and produces worse results.

## Protocol

**Every exploration MUST follow this order:**

### Step 1: Read the map (always, first)

```
Read: docs/CODEBASE_MAP.md
```

This gives you architecture, file purposes, dependencies, and navigation guides — all in one read.

### Step 2: Target specific files using the manifest

```bash
# If you need to check freshness:
Read: docs/.mercator.json    # Check root_hash — if unchanged, skip re-exploration
```

The manifest contains per-file token counts and hashes. Use it to:
- **Skip unchanged files** — if hash matches, don't re-read
- **Estimate read cost** — token counts tell you how expensive a file is
- **Find specific files** — search the manifest instead of Glob/Grep

### Step 3: Read only what you need

Using the map and manifest, read targeted files with offset/limit for large ones.

**NEVER do this:**
```
Glob: **/*.ts          # Blind scan — wasteful
Grep: "function"       # Undirected search — noisy
```

**ALWAYS do this:**
```
Read: docs/CODEBASE_MAP.md     # Know the terrain
Read: src/api/routes.ts         # Target what you need
Read: src/api/auth.ts           # Based on the map
```

## Applies To

Every agent, every exploration, every project that has been mapped with `/mercator-ai`.

This includes:
- Feature planning
- Bug investigation
- Code review
- Refactoring
- Onboarding

## Auto-Freshness (Zero Token Cost)

The post-commit hook (`mercator-auto-refresh.sh`) automatically:

- **Post-commit hook** refreshes `docs/.mercator.json` on every git commit
- **TLDR cache** auto-invalidated for changed files on commit
- **Cost: ~2s Python execution, zero API tokens**

Only `CODEBASE_MAP.md` prose (architecture diagrams, descriptions) requires a manual `/mercator-ai` update when modules are added/removed.

## Efficiency Gains

| Task | Without Map | With Map-First |
|------|------------|----------------|
| "Where is auth?" | ~15k tokens (blind scan) | ~2k tokens (read map → target file) |
| "Understand API layer" | ~8k tokens (read multiple files) | ~1.5k tokens (map summary + targeted read) |
| "Any changes since last time?" | ~15k tokens (re-scan everything) | ~50 tokens (compare root hash) |

## Unified Merkle System

The `.mercator.json` manifest uses a hierarchical merkle tree:

```
root_hash: "a1b2c3d4e5f6"        ← O(1) "anything changed?"
├── src/: "f1e2d3c4b5a6"          ← O(1) "src/ changed?"
│   ├── api/: "..."               ← drill down to changed module
│   │   ├── routes.ts: "..."      ← individual file hash
│   │   └── auth.ts: "..."
│   └── lib/: "..."
└── tests/: "..."
```

**Pipeline:**
```
git commit
  → hook detects commit
  → scanner runs --diff against manifest
  → manifest refreshed with new hashes
  → TLDR cache invalidated for changed files
  → agent reads updated manifest on next exploration
```

## Commands

```
/mercator-ai              # Full map (or update existing)
docs/.mercator.json        # Merkle manifest (auto-refreshed)
docs/CODEBASE_MAP.md       # Architecture documentation
```
