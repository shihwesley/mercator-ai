# Changelog

All notable changes to mercator-ai will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-02-23

### Fixed
- Flatten plugin structure so `/mercator-ai` registers as a slash command (e7b5117)
- Replace marketplace wrapper with flat plugin manifest for correct cache resolution (8fdd404)

### Other
- Fix marketplace name in install commands and manifest (7f3c431)
- Fix Mermaid diagram rendering on GitHub, remove Scanner CLI section (1d2af4a)
- Audit fixes, marketplace URL update, README overhaul, new command (270f179)

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
