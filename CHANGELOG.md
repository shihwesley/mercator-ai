# Changelog

All notable changes to mercator-ai will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-06

### Added
- Core codebase scanner (`scan-codebase.py`) with token counting via tiktoken and SHA-256 hashing
- Merkle tree construction with hierarchical directory hashes and single root hash
- `--diff` mode for O(1) change detection against a previous manifest
- `--format` options: json, tree, compact, merkle
- Parallel Sonnet subagent orchestration via SKILL.md
- Post-commit hook (`mercator-auto-refresh.sh`) for zero-token manifest refresh
- TLDR cache invalidation for changed files on commit
- Map-first exploration protocol documentation
- `docs/.mercator.json` merkle manifest output
- `docs/CODEBASE_MAP.md` architecture documentation output
- Plugin manifest with PostToolUse:Bash hook registration
- Marketplace wrapper for plugin distribution

### Attribution
- Built upon [Cartographer](https://github.com/kingbootoshi/cartographer) by Bootoshi (MIT)
