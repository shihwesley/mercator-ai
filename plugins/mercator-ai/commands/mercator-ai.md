---
description: Map or update the current codebase's architecture documentation
argument-hint: [update]
allowed-tools: ["Read", "Write", "Edit", "Glob", "Grep", "Bash", "Task"]
---

# Mercator AI

Map or update the current project's codebase.

**Arguments:** $ARGUMENTS

## Routing

Load the mercator-ai skill using the Skill tool:

```
Skill: mercator-ai:mercator-ai
Args: $ARGUMENTS
```

Invoke the Skill tool with skill `mercator-ai:mercator-ai` and pass `$ARGUMENTS` as args. Follow its workflow (check for existing map/manifest, scan, spawn subagents, synthesize, write outputs).

If `$ARGUMENTS` contains "update" or "refresh", treat as an incremental update — run `--diff` first and only re-explore changed modules.
