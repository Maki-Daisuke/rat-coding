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

"Vibe Coding" — riding the AI's momentum on intuition — is fast and frictionless, but accelerates this drift. Spec-driven approaches go the other way and write everything down upfront, which is heavier than most projects need.

Rat-Coding sits between them: **start by talking, write down only the _why_, and let the AI carry the rest.**

## How it works

Rat-Coding rests on three small things:

|                            | What                                                                                             | Where     |
| -------------------------- | ------------------------------------------------------------------------------------------------ | --------- |
| 📰 **`README.md`**         | The project's press release. The idealized image of the product, written for users. _Mandatory._ | repo root |
| 🐀 **`doc/rationales.md`** | The durable "why". Every non-trivial design decision and the alternatives rejected. _Mandatory._ | repo      |
| 🗺️ **`doc/design.md`**     | A map of the implementation, for contributors who want one. _Optional._                          | repo      |

That's it. **No spec, no ticket archaeology, no parallel design tree.** The source code is part of the Single Source of Truth — modern AI can explain code on demand, so the docs only need to carry what code _can't_ encode: the reasoning.

The practice is enforced by two VS Code customizations (this repo ships both):

- **An always-on instructions file** that teaches the agent to ask "why?", check past rationales for contradictions, and flag drift between docs and code.
- **A skill** (`/rat-init`, `/rat-audit`, …) for the recurring rituals — scaffolding a new project, auditing implementation drift, capturing a fresh rationale.

> The VS Code integration is the reference implementation. The practice itself — pair every decision with a rationale, treat that file as code the AI reads — travels to any agent or editor.

## Quick start

> 🚧 _The instructions file and skill are still being built. Below is the intended UX — the rationales for every choice are already in [`doc/rationales.md`](./doc/rationales.md)._

### Install (per workspace)

Rat-Coding ships as two VS Code Copilot customizations: an instructions file and a skill. By default they install into the current workspace (`.github/` and `.vscode/`), so each project opts in explicitly and you can pin a known-good version per repo.

From the root of the repo you want to use Rat-Coding in:

```pwsh
# Windows (PowerShell)
iwr https://raw.githubusercontent.com/yanother/rat-coding/main/install.ps1 | iex

# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/yanother/rat-coding/main/install.sh | sh
```

After install, the rules are active for that workspace and the slash commands (`/rat-init`, `/rat-audit`, …) are available in Copilot Chat there.

> Want it everywhere? Pass `--user` (or `-User` in PowerShell) to install into your VS Code user folder instead, and Rat-Coding applies to every workspace.

### Bootstrap a project

Open Copilot Chat in an empty (or existing) repo and run:

```
/rat-init
```

The skill will:

1. Ask one or two questions about what you want to build.
2. Scaffold `README.md` and `doc/rationales.md` (seeded with its first entry: _"Why this project exists"_).
3. Hand the keyboard back to you.

### Day-to-day

Just talk to your agent the way you always would:

> _"I want to add a CLI for converting CSV to JSON."_

The instructions file teaches the agent to (a) read `doc/rationales.md` first, (b) ask **why** before non-trivial choices, and (c) append a short rationale entry whenever a decision is made. You write code; the _why_ accumulates on its own.

When you suspect drift, run `/rat-audit` and the agent will compare recent code against the rationales and flag anything inconsistent.

## Philosophy

A few principles that drive every choice in this repo. The full reasoning lives in [`doc/rationales.md`](./doc/rationales.md).

- **Iterative dialogue, not phased workflow.** Nobody knows the right product up front — not even the person building it. The AI isn't an executor for a plan you decided in advance; it's a collaborator who grows the product with you, one turn at a time.
- **Code is part of the truth.** Rat-Coding does not treat the spec as the single source of truth. You are encouraged to read the code together with the AI — let it explain, discuss, point at lines, and refine the rationale through that contact — instead of shipping a spec and waiting for a finished product.
- **Small docs, big context budget.** LLM context windows are finite. Every redundant page in the repo is context stolen from the actual problem. Keep the rats small.
- **Flag, don't block.** The agent should _surface_ contradictions and ask. Hard rules that override the user's judgment turn a tool into a creed.

> Rat-Coding was made for the user, not the user for Rat-Coding.

## Status

Early. The rationales are written, the README you are reading exists, and the rest is on its way — built one "why?" at a time. Watch this space.

## License

[MIT License](./LICENSE).

## Author

Daisuke (yanother) Maki.
