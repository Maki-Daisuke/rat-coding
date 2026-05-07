# Design Map

This file is the implementation map for Rat-Coding contributors and AI agents. For the product press release, see [`README.md`](../README.md). For the reasoning behind each design decision, see [`rationales.md`](./rationales.md).

## Directory Structure

```
rat-coding/
├── AGENTS.md              # Symlink → skills/rat-init/assets/AGENTS.md (installed into consumer repos by /rat-init)
├── README.md              # Project press release
├── LICENSE
├── doc/
│   ├── rationales.md      # AI runtime spec — the durable "why"
│   └── design.md          # This file — implementation map
└── skills/                # Public skill collection (source; consumed by skill managers)
    ├── rat-init/
    │   ├── SKILL.md
    │   └── assets/        # Template files bundled with /rat-init
    │       ├── AGENTS.md          # Template for consumer AGENTS.md
    │       ├── README.md.tmpl
    │       ├── rationales.md.tmpl
    │       └── design.md.tmpl
    ├── rat-architecture/
    │   └── SKILL.md
    ├── rat-audit/
    │   └── SKILL.md
    ├── rat-feature/
    │   └── SKILL.md
    └── rat-compaction/
        └── SKILL.md
```

## `AGENTS.md` Is a Symlink

`AGENTS.md` at the repo root is a symbolic link to `skills/rat-init/assets/AGENTS.md`. The canonical source of the always-on rules lives in the `rat-init` asset bundle — the file that `/rat-init` installs (or offers to merge) into consumer repos. The symlink ensures that working in this repository itself is also governed by those same rules, without maintaining a second copy that could drift.

## Key Artifacts and Their Audiences

| Artifact                  | Audience                                                               | Notes                                                                                                      |
| ------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `AGENTS.md`               | AI agents working **in this repo** and as install source for consumers | Symlink to `skills/rat-init/assets/AGENTS.md`; `/rat-init` installs the symlink target into consumer repos |
| `skills/*/SKILL.md`       | Skill managers and, transitively, AI agents                            | Source of truth for skill content                                                                          |
| `skills/rat-init/assets/` | `/rat-init` skill at runtime                                           | Templates scaffolded into consumer repos                                                                   |
| `doc/rationales.md`       | AI agents working **in this repo**                                     | Loaded every session; the runtime spec                                                                     |
| `doc/design.md`           | AI agents and contributors working **in this repo**                    | This file                                                                                                  |
