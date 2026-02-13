# CLAUDE.md

## Codebase Overview

Claude Code plugin that maps codebases using parallel Sonnet subagents with Merkle-tree change detection. Fork of Bootoshi's Cartographer with added O(1) staleness checks, post-commit auto-refresh, and TLDR cache integration.

**Stack**: Python (scanner), Bash (hooks, release), Markdown (skill definition, protocol docs)
**Structure**: Marketplace wrapper at root, actual plugin in `plugins/mercator-ai/`

For detailed architecture, see [docs/CODEBASE_MAP.md](docs/CODEBASE_MAP.md).
