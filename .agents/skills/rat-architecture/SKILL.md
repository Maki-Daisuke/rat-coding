---
name: rat-architecture
description: "Propose architecture and framework choices for a Rat-Coding project based on README.md and doc/rationales.md, investigate similar off-the-shelf products, present honest trade-offs, incorporate user preferences, and initialize the project with ecosystem-standard tooling after an explicit decision. When architecture/framework is obvious from the requested product shape, present one clear option instead of forcing multiple options. Use when the user runs /rat-architecture or asks for architecture/framework selection. Assumes README.md and doc/rationales.md already exist (typically from /rat-init)."
license: MIT
---

# /rat-architecture - Architecture and Framework Selection

## What this skill does

`/rat-architecture` turns a product intent (from `README.md`) and durable reasoning (from `doc/rationales.md`) into an explicit architecture decision.

It does five things in sequence:

1. Reload project intent and constraints.
2. Investigate similar existing products (buy/adopt/compose alternatives).
3. Propose 2-3 architecture + framework options unless the product shape explicitly dictates a single clear choice, in which case propose that option only.
4. Incorporate user preferences and get an explicit choice.
5. Initialize the project with the chosen ecosystem's standard tooling and layout (only after approval).

See [Why `design.md` Is Optional, Not Required, but Recommended](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-designmd-is-optional-not-required-but-recommended) for why conventional structure and a clear map matter for future sessions.

## Preconditions

Before starting, verify that the repository already has:

- `README.md`
- `doc/rationales.md`

If either is missing, stop and suggest `/rat-init` first. Do not invent product intent from thin air.

## Procedure

### 1. Reload the project truth

Read `README.md`, `doc/rationales.md`, and `doc/design.md` (if present) before proposing any stack.

Extract the constraints that architecture must satisfy, including:

- Intended users and usage surface (CLI, web app, API, library, automation, etc.)
- Reliability, latency, throughput, and operability expectations
- Distribution constraints (single binary, package manager, container, hosted service)
- Security and compliance constraints already on record
- Existing rationale boundaries and non-goals

### 2. Ask for user preferences and constraints

Ask for explicit preferences before proposing options. Useful prompts:

- Language/runtime preferences or exclusions
- Team familiarity and hiring/maintainability concerns
- Hosting and operations preferences (serverless, containers, managed PaaS, on-prem)
- Budget constraints (build cost and ongoing run cost)
- Delivery constraints (prototype speed vs long-term robustness)

If the user has a strong preference, treat it as a first-class input and optimize within it rather than ignoring it.

### 3. Investigate similar existing products

Do external research and surface realistic alternatives. Include at least:

- Existing products/services that already solve the problem fully or partially
- Libraries/frameworks/starter platforms that reduce build scope
- Composition approaches using tools the user already has

For each relevant alternative, state clearly:

- What it solves well
- What it does not solve for this project
- Operational or vendor-lock-in risk
- Cost and control trade-off
- Security posture implications

Do not hide "do not build" as a valid recommendation. If buy/adopt is better, say so plainly.

### 4. Propose architecture options with honest trade-offs

By default, present 2-3 architecture options that can realistically satisfy the product intent.

If the product shape makes the choice effectively obvious (for example, the user explicitly wants to build a React component), do not force artificial alternatives. Present one clear option and explain briefly why it is the natural fit.

Each proposed option should include:

- Architecture shape (major components and boundaries)
- Framework/tooling choice
- Data/storage and integration approach (when relevant)
- Deployment model
- Testability and observability implications
- Migration path if the product grows

For each option, list explicit merits and drawbacks. Be candid about failure modes, complexity, and lock-in.

Then recommend one default option and justify it against:

- Product intent in `README.md`
- Current rationale constraints
- User preferences
- Risk profile

### 5. Decide explicitly with the user

Get explicit confirmation before proceeding.

- If the user chooses an option, continue with that option.
- If the user asks you to choose, choose one and record why.
- If the user is still uncertain, leave a `TODO:` in `doc/rationales.md` and stop. Do not force a false certainty.

### 6. Record the decision in docs before initialization

Update `doc/rationales.md` with a dedicated architecture decision section that includes:

- Chosen architecture/framework
- Alternatives considered (including adopt/buy/do-not-build)
- Why the chosen option won
- Premises and conditions that would trigger re-evaluation

If the product framing changed, also update `README.md`.
If module/layout expectations changed, update `doc/design.md` (if present).

Do not run init commands before this rationale update is captured.

### 7. Initialize with ecosystem-standard tooling

Once architecture/framework is chosen and documented, initialize using each ecosystem's canonical starter tools and default layout.

Rules:

1. Confirm the initialization method with the user first (for example: Vite vs Next.js, `cargo init` vs `cargo new`, root vs subdirectory scaffold).
2. State the exact command(s) you will run.
3. Ask for explicit approval.
4. Run only after approval.
5. Summarize created files/directories and resulting structure.

Examples (illustrative):

- Go: `go mod init <module-path>`
- Node/TypeScript library: `npm init -y` then `tsc --init`
- React (Vite): `npm create vite@latest <app-name> -- --template react-ts`
- Next.js: `npx create-next-app@latest <app-name>`
- Python: `uv init` (preferred) or `poetry new <name>`
- Rust: `cargo init` or `cargo new <name>`

Never invent a custom directory structure when a de facto standard initializer exists.

### 8. Hand the keyboard back

Finish with a concise summary:

- Chosen architecture/framework
- Why it was chosen
- Alternatives rejected and why
- Files/docs updated
- Initialization commands run (or intentionally deferred)

## What you must not do

- Do not skip reading `README.md` and `doc/rationales.md`.
- Do not skip researching existing products and alternatives.
- Do not hide drawbacks; present pros and cons honestly.
- Do not ignore explicit user preferences.
- Do not run initialization commands without first confirming the initialization method and then getting explicit approval.
- Do not invent non-standard layouts when standard tooling exists.
- Do not leave docs and implementation decisions out of sync.
