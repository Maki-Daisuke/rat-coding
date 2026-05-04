---
name: rat-audit
description: "Audit a Rat-Coding project for drift between README.md, doc/rationales.md, optional doc/design.md, tests, and implementation. Use when the user runs /rat-audit or asks whether the docs, rationales, design map, tests, and code still agree. Reports contradictions, missing rationale, stale design maps, uncovered behavior, oversized rationale sections, and unresolved TODOs without auto-fixing them."
license: MIT
---

# /rat-audit - Audit Rat-Coding Drift

## What this skill does

`/rat-audit` checks whether a Rat-Coding project still tells one coherent story across its Single Source of Truth:

- `README.md` - the product press release.
- `doc/rationales.md` - the durable why and the AI runtime spec.
- `doc/design.md` - the optional implementation map, if present.
- Tests - the executable specification of behavior, if present.
- Implementation - the behavior that users and contributors actually get, if present.

It is a report-only audit. It flags contradictions, missing information, stale premises, stale maps, uncovered behavior, unresolved `TODO:` markers, and rationale sections that are growing too large to stay useful in context. It does not decide which source is correct and it does not edit files automatically.

See [Why `/rat-audit` Is a Report-Only Drift Audit](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-rat-audit-is-a-report-only-drift-audit) for the design rationale.

## Preconditions

Before starting, verify that the repository has:

- `README.md`
- `doc/rationales.md`

If either is missing, this is not yet an auditable Rat-Coding project. Stop and suggest `/rat-init` if the user is trying to bootstrap the project. Do not invent product intent or rationales.

`doc/design.md` is optional. If it is missing, say so in the report and skip design-map checks.

## Procedure

### 1. Reload the project truth

Read, in parallel where possible:

- `README.md`
- `doc/rationales.md`
- `doc/design.md` if it exists
- The top-level directory structure
- Project guidance, contribution, workflow, and automation files, if they define how the project is built, tested, released, or used
- Test files and configuration, if present
- Implementation files and package/build metadata, if present

Prefer focused reading over loading the whole repository blindly. Use the docs and directory map, if present, to decide which implementation and test files matter most. If there is no implementation or no tests yet, record that as not applicable unless the docs claim they exist.

### 2. Extract the claims from each source

Build a short working model of what each source says.

From `README.md`, extract:

- The product's purpose and target user.
- Public workflows and commands the user is told to run.
- Installation, usage, and status claims.
- Any promised features, files, integrations, commands, APIs, or operational behavior.

From `doc/rationales.md`, extract:

- Decisions that constrain current behavior.
- Rejected alternatives and non-goals.
- Premises that may have gone stale.
- Requirements about small documents, optional `doc/design.md`, code/tests as truth, and any documented boundaries between warnings, approvals, and hard enforcement.
- `TODO:` markers or unresolved questions.

From `doc/design.md`, if present, extract:

- The directory map.
- Module responsibilities and public surfaces.
- Architecture claims that should be visible in code.

From tests, if present, extract:

- The behavior they make executable.
- Public APIs, commands, or workflows they cover.
- Important behavior described in docs but not covered by tests.

From implementation, if present, extract:

- Actual public surfaces: commands, flags, APIs, exported functions, config keys, generated files, installers, services, jobs, and user-visible workflows.
- Dependencies, runtimes, and architectural layers.
- Behavior that contradicts, exceeds, or falls short of the docs.

### 3. Audit for drift

Check the project from multiple angles.

**Document-to-document drift**

- Does the README promise a workflow, command, installation path, status, or file layout that `doc/rationales.md` contradicts?
- Does `doc/rationales.md` describe a decision that the README no longer reflects, where user-facing expectations would change?
- If `doc/design.md` exists, does its map match the README's and rationales' view of the project?

**Rationale internal drift**

- Do later rationales contradict earlier ones without explicitly overturning them?
- Do recorded premises still look true?
- Are rejected alternatives later reintroduced without explanation?
- Are `TODO:` markers still unresolved in areas that now appear decided?
- Is any section too large or unfocused for a file that must fit in the agent context every session?

**Design map drift**

- If `doc/design.md` exists, does its directory tree match the actual top-level layout?
- Are new modules, commands, services, jobs, packages, or architectural layers missing from the map?
- Does the map claim files or modules that no longer exist?

**Doc-to-implementation drift**

- Does the implementation provide the public surfaces the README and rationales describe?
- Has the implementation added a non-trivial public surface, dependency, runtime, architectural layer, or behavior without a rationale?
- Do project configuration, automation, and operational workflows follow recorded constraints?
- Does the implementation match the enforcement level documented in the rationales, such as warning, asking for approval, blocking, or rejecting?
- Does implementation behavior expose security, privacy, or privilege risks that the rationales do not mention?

**Doc-to-test drift**

- Do tests cover the behavior the README and rationales make important?
- Do tests encode behavior that docs or rationales reject?
- Are there important non-trivial behaviors with neither tests nor an explicit rationale explaining why they are not tested yet?

**Early-project checks**

- If the repository is still mostly documentation, scaffolding, or configuration, do not report missing application code as a defect unless the docs claim it exists.
- Focus instead on whether the product intent, setup story, rationale record, and optional design map are coherent.

### 4. Classify findings

Lead with findings, ordered by severity.

Use severity based on user impact and Rat-Coding integrity:

- **Critical** - The project instructs users, maintainers, or automation to do something unsafe, destructive, or directly contrary to a hard safety constraint.
- **High** - A documented public workflow is wrong, a rationale is clearly contradicted by implementation, or the audit finds a decision that should have a rationale but does not.
- **Medium** - The design map, tests, or documentation are stale enough to mislead future work, but the core user promise still mostly holds.
- **Low** - Small omissions, unresolved `TODO:` markers, weak cross-references, or rationale-health issues that should be cleaned up before they compound.

For each finding, include:

- The affected file(s) and, when useful, line references.
- What each source says.
- Why that disagreement matters.
- The question the user needs to answer, if a choice is required.
- A suggested next step, phrased as a proposal rather than an automatic fix.

If there are no findings, say so clearly. Still mention residual risks, especially untested areas or files not inspected.

### 5. Do not auto-fix

Do not edit files during the audit itself.

If the user asks to fix a finding after the report:

- If the fix is a pure bug fix or doc correction that restores an existing rationale, propose the smallest focused edit and ask for approval before changing files.
- If the fix changes product behavior, adds/removes a public surface, introduces a dependency, changes architecture, or overturns a rationale, route the work through `/rat-feature` or the relevant Rat-Coding dialogue before implementation.
- Never commit, stage, push, or run destructive commands unless the user explicitly asks for that operation.

### 6. Report format

Use this structure:

1. **Findings** - findings first, ordered by severity. If none, state that directly.
2. **Open Questions** - only questions that block choosing the correct source of truth.
3. **Coverage** - what was inspected and what was not applicable or not present.
4. **Suggested Follow-up** - concise proposals for how to address findings, without editing automatically.

Keep the report compact. The audit should make drift visible, not become a second specification.

## What you must not do

- Do not skip reading `README.md` and `doc/rationales.md`.
- Do not treat `doc/design.md` as required.
- Do not silently choose whether code, tests, README, or rationales are correct when they conflict.
- Do not auto-edit, auto-stage, auto-commit, or auto-push.
- Do not turn the audit into a style, lint, or generic code-quality review.
- Do not judge whether a rationale is aesthetically good; audit whether it is coherent, current, compact, and useful to the agent.
- Do not report missing implementation or tests as a defect in an early project unless the docs claim they exist.
- Do not let discovered drift turn into an undocumented new decision. If fixing it requires a new decision, route it through Rat-Coding rationale capture first.
