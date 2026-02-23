# Attribution

## Original Work

**Mercator AI** is built upon [Cartographer](https://github.com/kingbootoshi/cartographer) by [Bootoshi](https://github.com/kingbootoshi), licensed under MIT.

### What came from Cartographer

- Core file scanning logic (`scan-codebase.py` — directory walking, token counting, gitignore parsing)
- Parallel subagent orchestration pattern (Opus plans, Sonnet reads)
- `CODEBASE_MAP.md` output format and structure
- Plugin scaffolding (`.claude-plugin/plugin.json`)

### What Mercator AI adds

- **Merkle tree hashing** — SHA-256 hash per file, hierarchical merkle tree per directory, single root hash for the entire codebase
- **O(1) change detection** — compare root hashes to know instantly if anything changed
- **`--diff` mode** — compare current scan against previous manifest, output only changes (added/changed/removed files)
- **`--format merkle`** — output just the merkle tree for lightweight manifest storage
- **Post-commit hook** (`mercator-auto-refresh.sh`) — automatically refreshes merkle manifest after every git commit, zero LLM tokens consumed
- **TLDR cache invalidation** — clears cached file summaries for changed files on commit (graceful degradation if TLDR not present)
- **Map-first exploration protocol** — documentation teaching AI agents to use the map before blind Glob/Grep scanning
- **`.mercator.json` manifest** — structured manifest with per-file hashes and token counts for surgical codebase exploration

## Thank you

Bootoshi's Cartographer established the pattern of using parallel AI subagents to map codebases. Mercator AI builds on that foundation with change detection, staleness prevention, and an agent-oriented exploration protocol.

If you find value in the core mapping concept, please also star the original: https://github.com/kingbootoshi/cartographer
