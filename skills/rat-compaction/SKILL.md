---
name: rat-compaction
description: "Lighten an oversized Rat-Coding doc/rationales.md by preserving active decisions in a small runtime kernel and moving detailed history into focused supporting rationale files. Use when /rat-audit reports rationale bloat, when doc/rationales.md exceeds its size budget, or when the user asks to compact or lightweight rationales. Requires README.md and doc/rationales.md."
license: MIT
---

# /rat-compaction - Lightweight Oversized Rationales

## What this skill does

`/rat-compaction` repairs the Rat-Coding failure mode where `doc/rationales.md` grows too large to remain a useful always-loaded runtime spec.

It does not delete history. It reshapes rationale content into two layers:

- `doc/rationales.md` - the always-loaded runtime kernel: active decisions, premises, non-goals, and routing pointers.
- Supporting files such as `doc/rationales/*.md` - detailed history, extended alternatives, superseded background, and subsystem-specific reasoning that should be loaded only when relevant.

See [Why `/rat-compaction` Is a Rationale Lightweighting Workflow](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-rat-compaction-is-a-rationale-lightweighting-workflow) for the design rationale.

## When NOT to use this skill

Skip `/rat-compaction` when:

- The user is adding a new feature or changing product behavior. Use `/rat-feature` instead.
- The user wants a report only. Use `/rat-audit` instead.
- `doc/rationales.md` is already small, current, and easy to load.
- The requested edit would change a decision's meaning rather than preserve it. That is a new rationale decision, not compaction.

## Preconditions

Before starting, verify that the repository has:

- `README.md`
- `doc/rationales.md`

If either is missing, stop and suggest `/rat-init` if the user is trying to bootstrap the project. Do not invent product intent or rationales.

`doc/design.md` is optional. Read it if present, because it may point to subsystem boundaries that make good supporting-file boundaries.

## Procedure

### 1. Reload the project truth

Read, in parallel where possible:

- `README.md`
- `doc/rationales.md`
- `doc/design.md` if it exists
- Any existing files under `doc/rationales/`
- The latest `/rat-audit` report if the user provided one

Extract:

- The project purpose and user promise.
- Active decisions that still constrain work.
- Superseded, historical, or deeply detailed material.
- Existing cross-links and anchors that may break if content moves.
- Any explicit rationale size budget.

### 2. Establish the size budget

If the project already records a size budget for `doc/rationales.md`, use it.

If no budget exists, propose a soft budget and ask the user to confirm before editing. The proposal should be practical rather than universal; for example, target an always-loaded file that remains short enough for the agent to read every session alongside the relevant code.

Do not treat the budget as a hard gate that blocks the user. It is a context-health trigger: exceeding it means the file should be reviewed for lightweighting.

### 3. Classify rationale material

For each section in `doc/rationales.md`, classify it as one of:

- **Kernel** - must remain in the always-loaded file because future decisions depend on it frequently.
- **Kernel summary plus detail** - the conclusion, premises, non-goals, and load conditions stay in `doc/rationales.md`; detailed history moves to a supporting file.
- **Detail only** - useful history or extended background that should live outside the always-loaded file and be referenced from the kernel.
- **Superseded** - no longer governs behavior, but should be preserved with a clear pointer to the active replacement.
- **Stale or contradictory** - cannot be compacted honestly until the user decides which source of truth should move.

If you find stale or contradictory material, stop and surface it. Do not hide unresolved drift inside a compaction.

### 4. Propose the compaction plan

Before editing, present a compact plan that names:

- The target size budget and whether the current file exceeds it.
- Sections that will stay in `doc/rationales.md` as kernel material.
- Sections that will be summarized in `doc/rationales.md` and moved to supporting files.
- New supporting files to create under `doc/rationales/`, if any.
- Links or anchors that must be preserved or updated.
- Any open questions that block safe compaction.

Get explicit user approval before editing. The user owns the judgment of what must remain always loaded.

### 5. Rewrite without changing decisions

After approval, edit in this order:

1. Create or update supporting rationale files with the moved detail.
2. Rewrite `doc/rationales.md` into a runtime kernel that keeps each active decision discoverable.
3. Add routing cues such as "Load details when..." so future agents know when to read the supporting file.
4. Preserve or update links from `README.md`, `AGENTS.md`, and skills if anchors changed.
5. Keep superseded decisions visible enough that rejected or overturned paths are not accidentally reintroduced.

The main file should still be understandable on its own. A future agent should be able to read only `doc/rationales.md` and know the active constraints plus which detail files matter for a given task.

### 6. Verify the compacted record

After editing, re-read the affected files and check:

- No active decision disappeared.
- Rejected alternatives and non-goals are still represented.
- Supporting files are linked from the kernel.
- Links and anchors still resolve within the repository or to the canonical upstream URL where required.
- The compacted `doc/rationales.md` is at or below the agreed budget, or the remaining overage is explained.
- `README.md` still describes the public workflow accurately.

If the repository has tests or validation commands for docs, run the relevant non-destructive checks.

### 7. Hand the keyboard back

End with a concise summary:

- The budget used.
- What stayed in the runtime kernel.
- What moved to supporting files.
- Any decisions that were not compacted because they need user judgment.
- Whether validation passed or could not be run.

## What you must not do

- Do not skip reading `README.md` and `doc/rationales.md`.
- Do not discard rationale content to hit the budget.
- Do not change the meaning of a decision during compaction.
- Do not hide stale, contradictory, or uncertain material behind a cleaner summary.
- Do not move everything out of `doc/rationales.md`; the always-loaded kernel is the point.
- Do not create supporting files without linking them from the kernel.
- Do not auto-edit without an approved compaction plan.
- Do not auto-stage, auto-commit, auto-push, or run destructive commands.
