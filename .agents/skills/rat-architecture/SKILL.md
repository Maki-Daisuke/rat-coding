---
name: rat-architecture
description: "Select an architecture and framework for a Rat-Coding project: re-read README and rationales to understand the product, research similar existing tools, propose concrete options with unfiltered trade-offs, incorporate user preferences, record the decision as a rationale, then initialize the project with the framework's standard scaffolding tool — which naturally produces the canonical directory structure. Use after /rat-init and before /rat-feature, or when a major architectural change is being considered."
license: MIT
---

# /rat-architecture — Choose Architecture and Initialize, the Rat-Coding Way

## What this skill does

`/rat-architecture` is the structured turn between documenting why the project exists (`/rat-init`) and adding individual features (`/rat-feature`). It answers "how should this product be built?" at the highest level — language, runtime, framework, and the project shape those choices produce.

Specifically, it:

1. Re-reads the project's current truth (`README.md`, `doc/rationales.md`) to understand what product needs to exist.
2. Investigates the landscape: similar existing tools, libraries, and frameworks relevant to this product domain.
3. Proposes concrete architecture options with honest, unfiltered trade-offs.
4. Holds a dialogue to incorporate user preferences, constraints, and prior experience.
5. Records the decision as a rationale entry in `doc/rationales.md` _before_ touching the filesystem.
6. Initializes the project using the chosen framework's standard scaffolding tool — which naturally produces the canonical directory structure for that ecosystem.
7. Reflects the resulting structure in `doc/design.md`.

## When to use this skill

Use `/rat-architecture` when:

- The project has been initialized with `/rat-init` but no code exists yet — the architecture has not been chosen.
- A major architectural change is being considered (adding a runtime, switching frameworks, introducing a new service layer).
- A new sub-system or service is being scaffolded within a larger project.

Do **not** use it for feature-level implementation choices — those belong in `/rat-feature` step 4.

## Procedure

### 1. Re-load the project's truth

Before proposing anything, read — in parallel where possible:

- `README.md`: the press release. What is the product, who uses it, what problem does it solve?
- `doc/rationales.md`: every "why" already on the record, especially architectural constraints already stated.
- `doc/design.md` if it exists: any existing structure the new architecture must fit into.

Extract from these:

- The **product's core purpose** and user-facing behavior — this shapes which runtime and framework matter.
- The **delivery target**: CLI tool, web service, library, desktop app, mobile app, embedded system, etc.
- Any **explicit constraints** already recorded: language preferences, platform requirements, team familiarity, performance requirements, licensing.
- Any **adjacent decisions** in `rationales.md` that the architecture must not contradict.

### 2. Investigate the landscape

Do not propose from prior training alone. Actively investigate:

- **Existing products in this space.** Search for tools, services, or libraries that already solve this problem (or a substantial part of it). For each, note: what it does, how it compares to this product's stated purpose, whether it is a better answer than building at all ("compose rather than build"), and whether it is a dependency candidate rather than a competitor.

- **Frameworks and runtimes suited to this delivery target.** For a CLI: Python/Click, Go/Cobra, Rust/Clap, Node/Commander, etc. For a web service: Express, FastAPI, Axum, Rails, etc. Surface the realistic candidates, not an exhaustive list.

Present findings in the dialogue below.

### 3. Propose architecture options

Propose **2–4 concrete architecture options** — enough to give the user a real choice without overwhelming. For each option:

- **Name and one-line summary**: e.g., "Python + Click + SQLite" or "Go monolith + embedded BoltDB."
- **Why it fits this product**: how it addresses the product's core purpose and delivery target.
- **Honest trade-offs** — what this option makes easy and what it makes hard or impossible. If an option has a serious downside for this product's shape, say so. The user cannot make a good decision on incomplete information.
- **Typical directory structure**: the canonical project shape this ecosystem produces, so the user can visualize what initialization produces.
- **Initialization command**: the standard tool/command used to scaffold this architecture (`cargo init`, `npx create-next-app`, `go mod init`, `poetry init`, etc.).

If one option is clearly the best fit, say so and explain why — but still present the alternatives so the user can push back.

### 4. Dialogue: preferences and constraints

After presenting the options, ask:

1. **Do you have a language preference?** Familiarity, team skills, and organizational standards often outweigh theoretical superiority. If the user prefers a language, work within it unless there is a hard reason not to — and if there is, name it.
2. **Do you have a framework preference, or prior experience with any of the options?** Prior experience dramatically reduces ramp-up cost.
3. **Are there constraints I haven't captured?** Deployment environment, target platform, existing infrastructure, licensing, budget.
4. **Is there anything that would make one of these options _wrong_?** Negative constraints are often the most clarifying.

Do not insist on a specific option. If the user prefers an option that is not your recommendation, state any remaining concerns clearly, and — if the user still prefers it — build the rationale around the chosen option. The user owns the decision.

If the user is uncertain, explore together: describe what development and deployment would feel like under each option, or sketch a mental model of a concrete scenario. It is fine to end with **"let's try A and revisit if we hit friction"** — the rationale can record that the decision is tentative.

### 5. Write the rationale _before_ initializing

Once a decision is reached, propose a rationale entry for `doc/rationales.md`:

- **Heading**: phrased as a "why" — _"Why we chose [framework/language]"_ or _"Why we use [architecture pattern]"_.
- **The chosen architecture**: language, framework, key libraries, and what that combination produces (runtime, deployment unit, etc.).
- **Why it fits this product**: the specific properties of this choice that match the product's purpose and constraints.
- **Alternatives considered**: the options from step 3 that were not chosen, and specifically why. "We rejected Go because the team is more familiar with Python, and iteration speed matters more than memory footprint at this scale" is useful; "Go didn't fit" is not.
- **User preferences incorporated**: if a preference drove or shaped the decision, record it.
- **Premises**: what must remain true for this decision to hold (e.g., "team size stays small," "deployment target remains a single server," "no real-time requirements emerge").
- **Known limitations**: what the chosen architecture makes hard, even if those limitations are acceptable now.

Show the proposed entry to the user and **get explicit approval before writing it to `doc/rationales.md`**. Then write it.

### 6. Initialize the project

With the rationale on the record and the user's approval, initialize the project using the **standard, canonical tool for the chosen framework**. Examples:

| Ecosystem | Command |
|-----------|---------|
| Node.js / TypeScript | `npm init`, `npx create-next-app`, `npx create-vite`, etc. |
| Python | `poetry init`, `uv init`, `django-admin startproject`, etc. |
| Rust | `cargo init` or `cargo new` |
| Go | `go mod init <module-path>` |
| Ruby | `bundle init`, `rails new` |

Do not hand-write a directory structure. Use the framework's own scaffolding tool — this produces the **idiomatic, community-standard layout** that documentation, tutorials, and future collaborators expect. Hand-crafted structures diverge from expectations and create friction.

If the scaffolding tool requires parameters (app name, template, flags), ask the user for the values before running. Do not guess at values that will be baked into the project.

After initialization:

- Confirm the directory layout matches what was described in step 3.
- Remove boilerplate files that are clearly irrelevant to this product (placeholder content, sample files) while keeping structural files the framework expects.
- Make an initial commit recording what was scaffolded and under which rationale.

### 7. Update `doc/design.md`

After initialization, update (or create) `doc/design.md` to reflect the actual directory structure produced:

- **Map section first**: a tree of top-level directories and key files, each with a one-line description. The map must match exactly what is on disk — no aspirational directories, no omissions. A map that does not match the layout is worse than no map.
- **Architecture section**: a brief description of the runtime, framework, and how requests or data flow through the system (if applicable).

### 8. Hand the keyboard back

End the skill with a short message:

- The architecture chosen and why (one line).
- What was initialized (files and directories created).
- The rationale entry that was written.
- Any open questions recorded as `TODO:` in the rationale.
- What comes next: `/rat-feature` to add the first feature.

## What you must not do

- **Do not propose an architecture without investigating the landscape first.** Recommendations based on prior training alone miss the current ecosystem state.
- **Do not soften trade-offs.** If an option is a poor fit for this product, say so even if the user seems to prefer it. State concerns clearly, then defer to the user's decision.
- **Do not initialize before the rationale is approved.** Scaffolding is not easily reversed; the rationale must be on record first.
- **Do not hand-write the directory structure.** Use the framework's standard scaffolding tool. Idiomatic structure is a property of the ecosystem, not of this skill.
- **Do not invent rationale content.** Record what was actually decided and why, including `TODO:` for genuinely open questions.
- **Do not drift into feature planning.** Architecture selected, project initialized, `design.md` updated — the skill ends here. Features are for `/rat-feature`.
