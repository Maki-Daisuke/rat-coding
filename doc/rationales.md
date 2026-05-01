# Design Rationales

This document records the reasoning behind key design decisions in Rat-Coding — the _why_, not just the _what_. For what Rat-Coding is and how to use it, see the [README](../README.md).

Rat-Coding is being built using Rat-Coding itself. This file is therefore both an artifact and a demonstration.

## Why Rat-Coding Exists

### The Problem: Rationale Evaporates in Fast AI-Assisted Development

When a developer pairs with an AI agent over many iterative sessions, the product grows quickly — but the **reasoning behind each decision** rarely survives the session it was made in. The next session, the AI has no memory of why a particular structure was chosen, why a feature was deliberately _not_ built, or what trade-offs were already considered and rejected. The developer has to re-explain context every time, or worse, doesn't notice when the AI silently contradicts a past decision.

The name encodes the response: **Rat** stands for **Rationale**, positioned against "Vibe Coding" — the popular style of letting the AI run on intuition and momentum. Vibe Coding optimizes for speed in the moment; Rat-Coding optimizes for the integrity of the product over time. (And yes, _rats are small_ — a property that turns out to matter, see below.)

### Why Iterative Dialogue, Not Phased Workflow

Rat-Coding deliberately does _not_ prescribe a sequence of phases — no "design phase, then implementation phase, then review phase." The reason is empirical: **nobody, not even the person building the product, knows from the start what the product actually needs to be.** A perfect spec written up front is a fiction. What actually happens in real development is that you build something, look at it running, realize "this isn't quite right" or "this could be better if...", and refine your own mental model of the ideal product through that contact with reality.

The spec-first stance assumes the spec _can_ be written first, but in practice the product, the maker, and the user all grow together through the iteration. Locking the spec in early freezes the wrong artifact.

What Rat-Coding aims to do instead is **accelerate that iteration loop with AI assistance, and amplify the per-iteration growth through dialogue with the AI**. Each turn is small, conversational, and immediately reflected in code or rationale. The AI is not handed a finished spec to execute; it is a collaborator helping the developer figure out what to build, one "why" at a time.

### Why So Few Required Documents (Code as Part of the SSoT)

Rat-Coding requires only two documents per project: `README.md` and `doc/rationales.md`. `doc/design.md` is recommended but optional. This minimalism is deliberate, and rests on two arguments — one philosophical, one pragmatic.

**Philosophically**, Rat-Coding rejects the Spec-Driven Development (SDD) premise that a written specification is the single source of truth and code is a derivable artifact. Executable code carries nuances — ordering, edge cases, exact API contracts — that natural language cannot fully express without becoming as long and precise as the code itself. A spec detailed enough to generate the code deterministically _is_ code, just written in a worse language. And the user runs the code, not the spec; when the two disagree, the code is what the user experiences.

So Rat-Coding treats **the source code as itself a constituent of the Single Source of Truth**, alongside `rationales.md`. What `rationales.md` adds is the one thing source code cannot capture: the reasoning behind decisions, especially decisions about what _not_ to build.

**Pragmatically**, this stance has become viable only recently because of LLMs. Modern AI can generate detailed natural-language explanations from source code on demand — a line-by-line walkthrough can be produced when needed, without maintaining a parallel document that drifts from reality. The previously assumed cost of "code is hard to read, so we need a spec" has dropped sharply, and with it the case for SDD-style spec-as-truth.

There is a second pragmatic benefit, specific to AI-assisted development: **LLM context windows are finite**. The harder the problem, the more context the agent needs for the problem itself. Every redundant document loaded into context is context stolen from problem-solving. By keeping required documentation small, Rat-Coding deliberately preserves context budget for the actual work.

This is the deeper reason Rat-Coding is _small_: not minimalism for its own sake, but because small documents are what fit alongside the code in a finite context window. The rats are small on purpose.

### Rat-Coding Is a Practice, Not a Document Format

Two adjacent ideas exist and neither is sufficient on its own.

**Code comments** capture the _what_ and sometimes the _how_, but they cannot record decisions about code that does not exist — like "we deliberately did not implement feature X."

**Architecture Decision Records (ADRs)** are much closer in spirit, and `rationales.md` may freely use ADR formatting internally. But ADRs alone are documents written by humans, for humans. A folder of ADRs the AI never reads is not meaningfully different from no ADRs at all.

**Ticket / issue trackers** are another common home for "why we did this" — every decision discussed in a GitHub issue, a Jira ticket, a PR comment thread. The record is rich but _scattered_ and _verbose_: any given rationale is buried somewhere across hundreds of artifacts, wrapped in long back-and-forth. Both cost context — searching to find it, and re-reading to extract it. Rat-Coding instead consolidates the durable "why" into one compact, comprehensive file that fits in context cheaply. (If a future tool — e.g. an MCP server that surfaces ticket conclusions on demand — changes this trade-off, the calculus could shift; the choice is about today's context economics, not philosophy.)

Rat-Coding's contribution is not a new document format — it is the **practice** that pairs durable rationales with explicit AI behavior: always ask why, always check past rationales, always flag contradictions.

### Why `README.md` Is Mandatory (Even Though Code Is Part of the SSoT)

If code is a constituent of the Single Source of Truth, an obvious objection is: why isn't `README.md` derivable from code too? Why is it required when `design.md` is not?

The answer is that `README.md` is not a description of the code — it is the project's **press release**.

Amazon famously practices [_working backwards_](https://www.amazon.jobs/content/en/our-workplace/leadership-principles): before any code is written, the team drafts the press release that would announce the finished product. The press release names the problem the product solves, the value to the user, and why the user should care — in a form so plain that a stranger gets it at a glance. If the press release is hard to write, _that is the signal that something essential about the product is missing_, and the team goes back to thinking. If the press release is compelling, the job becomes building the product that makes it true.

`README.md` is the GitHub equivalent. A reader landing on the repository must, within seconds, understand what the product is, what problem it solves, and why they would want it. That description is not a mechanical summary of the code — it is the **idealized image of the product**, including value, intended use, and audience. Source code cannot generate that, because the value-to-the-user lens is precisely what code does not encode.

This also makes `README.md` a forcing function in the same way the press release is at Amazon: if you cannot write a compelling README, you do not yet have a product worth building. Requiring it from day one keeps Rat-Coding projects honest about whether they have a real reason to exist.

### `rationales.md` Is Code for the AI

The threads in this section converge on a single reframing that is worth stating directly: in Rat-Coding, **`rationales.md` is not documentation in the traditional sense — it is _code_, written for the AI as its runtime.**

Traditional documentation is a passive artifact, written for humans, read sometimes or never. `rationales.md` is the opposite: it is loaded into the agent's context every session, parsed by a model whose behavior it then conditions, and consulted as the authoritative record before any non-trivial decision. That is precisely the role source code plays for a CPU. The medium is natural language and the runtime is an LLM, but the relationship is the same — an executable artifact that, together with the source code, defines how the project behaves.

This reframing is not metaphorical decoration. It explains, in one stroke, every constraint Rat-Coding imposes on the file:

- **It must be small** — like binary size against memory, the file competes for context budget and must fit.
- **It must be structured** — section hierarchy, internal links, and consistent vocabulary are not stylistic preferences but a grammar the AI parses; broken structure produces wrong behavior, the same way malformed code produces wrong output.
- **It must not lie** — drift between rationales and source code is a runtime contradiction between two parts of the same SSoT, and the AI _will_ act on whichever it sees first. A stale rationale is not a stale doc; it is a bug.
- **It must record what was _not_ done** — code expresses positive behavior only; the AI's behavior depends just as much on negative space, which is where rationales become irreplaceable.

Together with the source code, then, `rationales.md` is what the AI _executes_ when it pairs with the developer. The README is the press release for humans; `rationales.md` is the runtime spec for the AI. Treating it with the same care as code — versioned, reviewed, audited for drift — is not a flourish, it is the only way the practice works.

## Why an Editor Integration

Rat-Coding is delivered as an **editor / agent integration**, not as a standalone CLI, a hosted service, or a fully autonomous coding agent. This shape follows directly from the methodology.

Rat-Coding treats **source code as part of the Single Source of Truth** (see [_Why So Few Required Documents_](#why-so-few-required-documents-code-as-part-of-the-ssot)). If code is part of the truth, then **reading code is part of the practice**. The user is expected to point at specific lines and discuss them with the AI, sometimes write code by hand, and treat the AI as a collaborator on shared source — not a vending machine that consumes a spec and emits a finished product.

A fully autonomous coding agent — one that takes a task, disappears, and returns with a pull request — is the wrong shape for this. It minimizes exactly the activity Rat-Coding wants to maximize: the user looking at the code with the AI, asking "why this?" and "what about that?", and refining the rationale through that contact. The autonomous-agent UX optimizes for the user _not_ reading the code; Rat-Coding optimizes for the opposite.

An **editor integration** is therefore the right shape: the user is already in the file, with the cursor on a specific line, and the AI is a turn away. Pointing at code, talking about code, and editing code are the same gesture.

Concretely, Rat-Coding ships as two plain-file artifacts that today's AI coding tools already read directly: an `AGENTS.md` at the repo root and one or more `SKILL.md` files under `.agents/skills/`. No plugin, no extension, no editor-specific manifest.

### Why Both Always-On Rules and On-Demand Skills

Rat-Coding splits its integration into two complementary pieces: an **always-on rules file** (`AGENTS.md`) and one or more **on-demand skills** (under `.agents/skills/`). Each alone fails for a specific reason.

**Rules alone** are right for the _philosophy_ — "always ask why," "always check past rationales" — because those need to be active in every conversation. But a rules file is pure prose: it cannot bundle template files, cannot define multi-step procedures invoked by name, and cannot appear as slash commands. Without those, every Rat-Coding setup would require manual scaffolding, defeating the "reproducible process" goal.

**Skills alone** can bundle templates and define workflows, but they load only when explicitly invoked or when their description matches the request. That is fatal for the philosophy: the agent should _spontaneously_ ask "why?" at the moments the user would otherwise forget — which is precisely the moments they will forget to type `/rat-something`.

The split matches a deeper distinction: **rules describe what kind of collaborator the AI should be at all times; skills describe specific tasks the user occasionally wants done** (`/rat-init` to scaffold docs, `/rat-audit` to check doc-implementation drift, etc.). Folding either into the other would bloat the always-on context with rarely-needed templates, or leave the philosophy dormant between explicit invocations.

A natural alternative would be to enforce some of these invariants with **deterministic hooks** — for instance, blocking a commit that lacks a rationale update. That was rejected: hard rules override the user's judgment, which is exactly the creed-style enforcement Rat-Coding refuses (see [`Rat-Coding was made for the user`](#why-designmd-is-optional-not-required)). The agent should _flag_ contradictions and ask, not block.

### Why Workspace-Scoped Install Is the Default

Rat-Coding's two artifacts can in principle be installed in two scopes: in the user's home directory (so they apply to every workspace) or in the repository itself (so they apply only to that repo, via committed `AGENTS.md` and `.agents/skills/` files). Rat-Coding's installer supports both, but **defaults to workspace-scoped**, with user-wide available behind an opt-in flag (`--user` / `-User`).

The reasoning prioritizes the **first-time encounter** over the **steady-state user**.

Workspace-scoped install wins on:

- **Opt-in per project.** Installing Rat-Coding into one repo does not silently change the agent's behavior in every other repo the user opens. Adopting a methodology should be a conscious act, not a side effect.
- **Lower trial cost.** Trying Rat-Coding is one command in the target repo, and uninstalling is deleting two paths. No global state to reason about. The lower the cost of trying, the more people actually try.
- **Travels with the repo.** Because the artifacts are committed, collaborators and CI agents pick up the same Rat-Coding rules automatically — Rat-Coding becomes a property of the project, not of the individual developer's laptop. This matches how `.editorconfig` and similar repo-scoped conventions work.
- **Per-repo version pinning.** A repo can pin a known-good version of the rules and skills independent of what other projects use, avoiding "I updated Rat-Coding globally and now three of my repos behave differently" surprises.

User-wide install would have been the alternative default, with non-trivial costs:

- **Re-installation per repo.** A developer who already loves Rat-Coding has to install it again in every new project — pure friction for the steady-state user.
- **Distributed updates.** Bumping to a new version means visiting every Rat-Coding-using repo, vs. one update for the user-wide case. A `/rat-update` ritual or similar becomes necessary.
- **Imposed on collaborators.** Committing `AGENTS.md` and `.agents/skills/` into a repo effectively decides for collaborators that Rat-Coding is in use. On personal projects this is a feature; on shared OSS repos it can be a review-friction surprise.
- **Drift across the developer's repos.** Versions can diverge between projects the same person works on, in ways that user-wide install would prevent.

The trade-off ultimately came down to: **the cost of friction is paid by everyone who tries Rat-Coding, including everyone who decides not to adopt it.** The cost of "re-install per repo" is paid only by people who already chose Rat-Coding and are now using it heavily. Lowering the barrier for the larger first group, at the price of mild friction for the smaller second group, was the better trade — and a `--user` flag preserves the user-wide path for anyone who wants it.

## Why `design.md` Is Optional, Not Required

The strict reading of "code is part of the SSoT" says `design.md` is redundant: the code shows _what_ was built, the rationales show _why_, and an architectural overview can be regenerated from code on demand. A purist setup needs only `README.md` and `rationales.md`.

But two real cases warrant a written `design.md`:

- **Bridging spec to implementation.** When a feature is being designed in conversation, decisions accumulate faster than they can be captured as discrete rationales. A `design.md` is a useful holding place for "here is the shape we decided to build," before any code exists.
- **Onboarding a contributor.** Code is the truth, but a several-thousand-line codebase is not the right entry point for a newcomer. `design.md` is a map — short, current, and pointing at the code rather than restating it.

Neither case is universal, so forcing one answer would either burden small projects with unused docs or leave large projects without a map. `/rat-init` therefore asks the user explicitly. This follows a more general principle:

> Rat-Coding was made for the user, not the user for Rat-Coding.

A methodology that overrides the user's judgment in the name of philosophical consistency has stopped being a tool and started being a creed. Rat-Coding picks the tool side of that line: the philosophy informs the defaults, but the user is always allowed to say "not this time."
