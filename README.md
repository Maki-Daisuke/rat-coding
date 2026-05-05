# Rat-Coding

> **A tiny rationale file as code, driving your AI agent.**

Rat-Coding is a lightweight development practice for working with AI coding agents. You start the way you'd start any AI session — _"hey, I want to build something like this…"_ — but every non-trivial decision gets one or two paragraphs in a single small file: **`doc/rationales.md`**. The AI loads that file every session and treats it as code: the runtime that conditions how it pairs with you on _your_ project.

The name says it: **Rat** is for **Rationale**. And rats are small — the rationale file is too. That is the whole trick:

- 🐀 **Small enough to fit in the context window.** The AI loads it _every_ session and actually reasons over it, instead of guessing or contradicting yesterday's decisions.
- 💬 **Light enough to start with a conversation.** No upfront spec, no design tree, no template gauntlet. You can begin Rat-Coding the same way you begin Vibe Coding: by talking.

## Why?

AI agents are wonderful at velocity. They are terrible at memory. After a few iterative sessions, the _what_ is in the code, but the _why_ has evaporated:

- Why is this structured this way? — _Nobody remembers._
- Why didn't we build feature X? — _Nobody remembers._
- The AI silently contradicts a past decision. — _Nobody notices._

"Vibe Coding" — riding the AI's momentum on intuition — is fast and frictionless, but accelerates this drift. Spec-driven approaches go the other way and write everything down upfront — a discipline that brings real rigor and works well in the right context, but that carries a setup cost many projects don't need from day one.

Rat-Coding takes a different path: **start by talking, write down only the _why_, and let the AI carry the rest.**

## How it works

Rat-Coding rests on three small things:

|                            | What                                                                                             | Where     |
| -------------------------- | ------------------------------------------------------------------------------------------------ | --------- |
| 📰 **`README.md`**         | The project's press release. The idealized image of the product, written for users. _Mandatory._ | repo root |
| 🐀 **`doc/rationales.md`** | The durable "why". Every non-trivial design decision and the alternatives rejected. _Mandatory._ | repo      |
| 🗺️ **`doc/design.md`**     | A map of the implementation, for contributors who want one. _Optional._                          | repo      |

That's it. **No spec, no ticket archaeology, no parallel design tree.** The source code is part of the Single Source of Truth — modern AI can explain code on demand, so the docs only need to carry what code _can't_ encode: the reasoning.

## Quick start

> 🚧 _`AGENTS.md` and the skills are usable, but the installer is still planned UX. The rationales for every choice are already in [`doc/rationales.md`](./doc/rationales.md)._

### Planned install (per workspace)

Rat-Coding ships as two artifacts: `AGENTS.md` at the repo root, and one or more skills under `.agents/skills/`. The planned installer will install them into the current workspace by default, so each project opts in explicitly and you can pin a known-good version per repo.

Once the installer exists, the intended commands from the root of the repo you want to use Rat-Coding in are:

```pwsh
# Windows (PowerShell)
iwr https://raw.githubusercontent.com/yanother/rat-coding/main/install.ps1 | iex

# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/yanother/rat-coding/main/install.sh | sh
```

After install, the rules will be active for that workspace and the slash commands (`/rat-init`, `/rat-audit`, …) will be available in any Copilot/Cursor/Claude Code/etc. chat there.

> Want it everywhere? The planned user-wide mode will accept `--user` (or `-User` in PowerShell) to install into your home directory instead, so Rat-Coding applies to every workspace.

### Bootstrap a project

Rat-Coding is a small loop, not a big process. Two skills usually run once near the start of a project, then the product-growth and rationale-health skills repeat as the product grows:

```mermaid
flowchart LR
  Init["/rat-init<br/>once: write the first why"] --> Architecture["/rat-architecture<br/>once: choose the stack"]
  Architecture --> Feature["/rat-feature<br/>repeat: add non-trivial change"]
  Feature --> Audit["/rat-audit<br/>repeat: check drift"]
  Audit --> Feature
  Audit --> Compaction["/rat-compaction<br/>as needed: lighten rationales"]
  Compaction --> Feature
```

To start, open Copilot Chat in an empty (or existing) repo and run:

```
/rat-init
```

The skill will:

1. Hold a short dialogue about what you want to build, why it matters now, what already exists, and what is deliberately out of scope.
2. Scaffold `README.md` and `doc/rationales.md` (seeded with its first entry: _"Why this project exists"_), and offer `doc/design.md` by default as an optional implementation map.
3. Hand the keyboard back to you with the first durable _why_ on the record.

Then, when you are ready to choose architecture/frameworks and initialize the codebase with standard ecosystem tooling:

```
/rat-architecture
```

That skill investigates similar existing products, proposes options with explicit trade-offs, incorporates your preferences, and initializes the project using de facto standard procedures after explicit approval.

After that, use `/rat-feature` whenever you add a non-trivial behavior, public surface, dependency, or architectural change. Use `/rat-audit` whenever you want to check whether the README, rationales, optional design map, tests, and implementation still agree. If the rationale file grows beyond its context budget, use `/rat-compaction` to keep `doc/rationales.md` as a small always-loaded runtime kernel while moving detailed history into supporting rationale files. Between those named workflows, `AGENTS.md` stays active as the always-on behavior: read `doc/rationales.md`, ask why before non-trivial choices, surface contradictions, and keep docs and code from drifting apart.

### Day-to-day

You can still start by talking to your agent normally:

> _"I want to add a CLI for converting CSV to JSON."_

If that turns out to be a non-trivial change, Rat-Coding should route the conversation through `/rat-feature`: clarify why, check alternatives, record the rationale, then implement. You can also invoke `/rat-feature` directly when you already know the change is non-trivial.

For small fixes, typos, formatting, and behavior-preserving cleanup, no feature workflow is needed. `AGENTS.md` remains active in the background: it reminds the agent to read `doc/rationales.md`, surface conflicts, and keep docs and code from drifting apart.

When you suspect drift, run `/rat-audit` and the agent will compare recent code against the rationales and flag anything inconsistent. When you suspect the rationale record is getting too large for cheap always-on loading, run `/rat-compaction` and the agent will preserve the durable why while compacting the main file into a smaller routing kernel.

## Philosophy

A few principles that drive every choice in this repo. The full reasoning lives in [`doc/rationales.md`](./doc/rationales.md).

- **Rationale is part of the product, and the AI's runtime.** `doc/rationales.md` carries the durable why so each session can continue from yesterday's reasoning.
- **Not building matters when building gets cheap.** AI makes code easy to add; Rat-Coding records rejected alternatives and non-goals so complexity is not added by default.
- **Truth grows through contact with reality.** Code, tests, README, and rationales each carry part of the truth; the product sharpens through dialogue with what actually runs.
- **Methodology should serve people, not rule them.** The agent surfaces contradictions and risks, then asks. It does not turn process into a creed.

> Rat-Coding was made for man, not man for Rat-Coding.

## Status

Early. The rationales are written, the README you are reading exists, and the rest is on its way — built one "why?" at a time. Watch this space.

## License

[MIT License](./LICENSE).

## Author

Daisuke (yanother) Maki.
