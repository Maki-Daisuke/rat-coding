# Design Rationales

This document records the reasoning behind key design decisions in Rat-Coding — the _why_, not just the _what_. For what Rat-Coding is and how to use it, see the [README](../README.md).

Rat-Coding is being built using Rat-Coding itself. This file is therefore both an artifact and a demonstration.

## Why Rat-Coding Exists

### The Problem: Rationale Evaporates in Fast AI-Assisted Development

When a developer pairs with an AI agent over many iterative sessions, the product grows quickly — but the **reasoning behind each decision** rarely survives the session it was made in. The next session, the AI has no memory of why a particular structure was chosen, why a feature was deliberately _not_ built, or what trade-offs were already considered and rejected. The developer has to re-explain context every time, or worse, doesn't notice when the AI silently contradicts a past decision.

The name encodes the response: **Rat** stands for **Rationale**, positioned against "Vibe Coding" — the popular style of letting the AI run on intuition and momentum. Vibe Coding optimizes for speed in the moment; Rat-Coding optimizes for the integrity of the product over time. (And yes, _rats are small_ — a property that turns out to matter, see below.)

### Why Iterative Dialogue, Not Phased Workflow

Rat-Coding deliberately does _not_ prescribe a sequence of phases — no "design phase, then implementation phase, then review phase." The reason is empirical: **nobody, not even the person building the product, knows from the start what the product actually needs to be.** A perfect spec written up front is a fiction. What actually happens in real development is that you build something, look at it running, realize "this isn't quite right" or "this could be better if...", and refine your own mental model of the ideal product through that contact with reality.

The spec-first stance works well when requirements are stable and well-understood up front. Rat-Coding targets a different situation: projects where the product, the maker's understanding of it, and the user's needs all grow and sharpen together through iteration. When that is the context, writing the full spec first means committing to a picture that has not yet been tested against reality.

What Rat-Coding aims to do instead is **accelerate that iteration loop with AI assistance, and amplify the per-iteration growth through dialogue with the AI**. Each turn is small, conversational, and immediately reflected in code or rationale. The AI is not handed a finished spec to execute; it is a collaborator helping the developer figure out what to build, one "why" at a time.

### Why So Few Required Documents (Code as Part of the SSoT)

Rat-Coding requires only two documents per project: `README.md` and `doc/rationales.md`. `doc/design.md` is recommended but optional. This minimalism is deliberate, and rests on two arguments — one philosophical, one pragmatic.

**Philosophically**, Rat-Coding starts from a basic principle: **deterministic things belong in deterministic languages.** Natural language is inherently ambiguous — meaning is recovered through interpretation, and the same sentence admits different readings in different contexts. Programming languages are unambiguous by design: a program means exactly what it means and executes identically every time. When the subject matter is itself deterministic — an algorithm, an API contract, a business rule — prose encoding loses precision and re-introduces interpretation at every reading. The right medium for deterministic description is the language that enforces determinism.

This is the starting point for Rat-Coding's divergence from Spec-Driven Development (SDD). SDD treats a written specification as the single source of truth and code as a derivable artifact — a stance that serves well when the domain is stable enough to specify precisely. Rat-Coding takes a different position: executable code carries nuances — ordering, edge cases, exact API contracts — that natural language cannot fully express without becoming as long and detailed as the code itself. A spec precise enough to generate the code deterministically is, in a real sense, already a program; it has just been written in a medium that does not execute. And the user runs the code, not the spec; when the two disagree, the code is what the user experiences.

The same principle extends to tests. Whether an implementation embodies the intended behavior is a deterministic question — for any given input, either it does or it does not. That question belongs in code. Test code is the executable, unambiguous expression of what "correct" means; it is the code-form of the specification. A natural-language description of expected behavior is a prose approximation of what a test suite states precisely. Where the two coexist, the test suite is authoritative. "The implementation should handle edge cases correctly" is not a spec; a failing test is.

So Rat-Coding treats **the source code as itself a constituent of the Single Source of Truth**, alongside `rationales.md`. What `rationales.md` adds is the one thing source code cannot capture: the reasoning behind decisions, especially decisions about what _not_ to build.

**Pragmatically**, this philosophical stance has become viable only recently because of LLMs. The historical objection to code-as-truth was that humans cannot read code as easily as prose, so a parallel natural-language spec seemed necessary for understanding, review, and onboarding. Modern AI removes that barrier: it can generate detailed natural-language explanations from source code on demand — a line-by-line walkthrough produced when needed, without maintaining a parallel document that drifts from reality. The previously assumed cost of "code is hard to read, so we need a spec" has dropped sharply, and with it the last serious obstacle to the philosophical position above.

There is a second pragmatic benefit, specific to AI-assisted development: **LLM context windows are finite**. The harder the problem, the more context the agent needs for the problem itself. Every redundant document loaded into context is context stolen from problem-solving. By keeping required documentation small, Rat-Coding deliberately preserves context budget for the actual work.

This is the deeper reason Rat-Coding is _small_: not minimalism for its own sake, but because small documents are what fit alongside the code in a finite context window. The rats are small on purpose.

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

### Rat-Coding Is a Practice, Not a Document Format

The reframing above — `rationales.md` as AI runtime, not documentation — clarifies what Rat-Coding adds over three approaches that already exist.

**Code comments** capture the _what_ and sometimes the _how_, but they cannot record decisions about code that does not exist — like "we deliberately did not implement feature X."

**Architecture Decision Records (ADRs)** are much closer in spirit. Entries in `rationales.md` can follow ADR structure — context, decision, alternatives considered, consequences — and often should. The difference is not format but role: a folder of ADRs the AI never reads is not meaningfully different from no ADRs at all. Rat-Coding takes the ADR content model and pairs it with explicit AI behavior.

**Ticket / issue trackers** are another common home for "why we did this" — every decision discussed in a GitHub issue, a Jira ticket, a PR comment thread. The record is rich but _scattered_ and _verbose_: any given rationale is buried somewhere across hundreds of artifacts, wrapped in long back-and-forth. Both cost context — searching to find it, and re-reading to extract it. Rat-Coding instead consolidates the durable "why" into one compact, comprehensive file that fits in context cheaply. (If a future tool — e.g. an MCP server that surfaces ticket conclusions on demand — changes this trade-off, the calculus could shift; the choice is about today's context economics, not philosophy.)

Rat-Coding's contribution is not a new document format — it is the **practice** that pairs durable rationales with explicit AI behavior: always ask why, always check past rationales, always flag contradictions.

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

A natural alternative would be to enforce some of these invariants with **deterministic hooks** — for instance, blocking a commit that lacks a rationale update. That was rejected: hard rules override the user's judgment, which is exactly the creed-style enforcement Rat-Coding refuses (see [`Rat-Coding was made for the user`](#why-designmd-is-optional-not-required-but-recommended)). The agent should _flag_ contradictions and ask, not block.

### Why `/rat-audit` Is a Report-Only Drift Audit

Rat-Coding needs an explicit `/rat-audit` skill because drift is the failure mode the practice is designed to fight: `README.md`, `doc/rationales.md`, optional `doc/design.md`, tests, and implementation can each become true in isolation while contradicting each other as a system. The always-on rules tell the agent to treat drift as a defect, but auditing is an occasional, focused activity that benefits from a named procedure and a consistent report shape. That makes it a skill rather than another always-on rule.

The audit is deliberately **report-only**. When it finds a contradiction, missing rationale, stale map, uncovered behavior, oversized rationale section, or unresolved `TODO:`, it should name the evidence and ask which source of truth should move. It should not decide silently that prose beats code, code beats prose, or tests beat both; Rat-Coding treats all of them as parts of the Single Source of Truth, and conflicts are decisions for the user. It should also handle early projects gracefully: if there is no implementation yet, the audit checks the documents and rationale health it can see, then says which implementation/test checks were not applicable.

Alternatives were rejected. A deterministic hook or CI gate would catch drift sooner, but would violate the "flag, don't block" principle. An auto-fixer would create the same problem in softer form by choosing the winning truth without dialogue. A narrow document-only audit would miss the most important contradictions, because Rat-Coding explicitly treats code and tests as part of the truth. A generic code review skill would find bugs, but would not know to compare the product press release, rationale runtime, design map, tests, and implementation as one Rat-Coding system.

The premises are that Rat-Coding remains an editor/agent practice, that `README.md` and `doc/rationales.md` remain mandatory while `doc/design.md` remains optional, and that the user's judgment remains the final arbiter when sources conflict. Non-goals: `/rat-audit` does not auto-edit files, auto-commit, run style/lint review as its main purpose, judge whether a rationale is aesthetically good, or replace `/rat-feature` when a discovered drift requires a new decision.

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

### Why Rat-Coding's Own Files Reference Upstream Docs by Absolute URL

`AGENTS.md` and the files under `.agents/skills/` will be **copied verbatim into every Rat-Coding-using repository**. That is how the install works (see [_Why Workspace-Scoped Install Is the Default_](#why-workspace-scoped-install-is-the-default)). Anything those files reference therefore has two possible meanings: the copy of the doc that lives _in this Rat-Coding repo_, or the copy that lives _in the consumer's repo_.

The two are not the same file. The consumer's `doc/rationales.md` is about the consumer's project. Rat-Coding's `doc/rationales.md` is about Rat-Coding itself.

If `AGENTS.md` or a skill says `[some rationale](../../../doc/rationales.md#...)`, that relative path resolves inside the consumer's repo — pointing at a file that does not contain the referenced section, or in a fresh project, does not exist at all. The link is silently broken in every install.

The rule, therefore:

- **Inside `AGENTS.md` and `.agents/skills/**`, never link to Rat-Coding's own `doc/rationales.md`, `README.md`, or `doc/design.md` by relative path.** Use the canonical upstream URL (`https://github.com/Maki-Daisuke/rat-coding/blob/main/...`) instead.
- **Relative links within the consumer's project are still fine** — e.g. a skill that scaffolds files for the consumer can reference the file paths it just created. Those paths resolve correctly _because_ they are about the consumer's repo, which is exactly where the skill is now running.
- **Inside `doc/`, relative links are the right choice** — `doc/rationales.md` and `doc/design.md` are not copied into consumer repos; they live only in Rat-Coding's own repo, so `../README.md` always points where it should.

The principle: a file's link style must match where the file will be read. Files that travel with the install must reference upstream by URL; files that stay home can use relative paths.

## Why `/rat-init` Is a Dialogue, Not a Template Drop

A simpler design would be to have `/rat-init` write empty `README.md` and `rationales.md` files from a template and exit. That option was rejected.

The Rat-Coding philosophy is **"ask why before writing,"** and the very first moment of a project is when that question matters most. Dropping empty templates leaves the user staring at blank headings, which is precisely the situation Rat-Coding was designed to avoid. A `README.md` that nobody could yet write a press release for is a project that does not yet have a reason to exist — and Rat-Coding wants that to be visible, not papered over.

So `/rat-init` is a **dialogue**, not a generator:

- It asks **what** the user wants to build.
- It asks **why** — what problem this solves, for whom, and what makes that problem worth solving.
- It investigates and surfaces **alternatives** the user may not have considered: existing tools, smaller compositions of what already exists, scope reductions. (This is the same "rationale for not building" stance that `AGENTS.md` describes for ongoing work, applied at project birth.)
- Only when the conversation has produced enough material does it scaffold `README.md` and `doc/rationales.md` — with the **first rationale entry** ("Why this project exists") already populated from the dialogue.

The skill ends by handing the keyboard back to the user, not by claiming the project is "set up." A Rat-Coding project is set up the moment the first real "why" is written down; `/rat-init` is just the structured nudge that gets you there.

### When the User Is Unsure, the Job Is to Explore — Not to Extract

The `/rat-init` dialogue is easy when the user already knows what they want. The interesting case is the opposite one: when the user themselves cannot yet articulate what the product is supposed to be.

The wrong response, and the tempting one, is to **extract** an answer — to keep narrowing questions until the user commits to _something_, just so the skill can finish and write the file. That produces a rationale that looks complete but is actually fabricated, and every future session built on top of it inherits the lie.

The right response is to **explore together**. Rat-Coding treats development as an exploratory activity (see [_Why Iterative Dialogue, Not Phased Workflow_](#why-iterative-dialogue-not-phased-workflow)): the product, the maker's understanding of it, and the user's needs all grow together through iteration. The user's "I don't quite know yet" is not a failure of preparation — it is the **starting condition** of a Rat-Coding project, and the AI's job at that moment is to help the user find the shape of what they want, not to demand they already have it.

Concretely, this means the AI should:

- Test the edges through follow-up questions ("what would make this _wrong_?", "who is the first person you'd show this to?") rather than asking for an executive summary.
- Reflect what it heard back in its own words and let the user correct it; clarity often emerges in the correction.
- Offer adjacent shapes the user can react to ("could this be X, or is it more like Y?"), since recognition is easier than generation.
- Be willing to end the dialogue with **"we don't know yet"** — a `TODO:` rationale that honestly names the open question is more valuable than a confident-sounding fabrication.

Whether the user comes in with full clarity or with only a vague pull toward something, what gets written into `rationales.md` must reflect **what is actually known at this moment** — including the gaps. The product, the rationale, and the user's understanding will all sharpen together in subsequent sessions; that is the practice. `/rat-init` is the first turn of that exploration, not the conclusion of it.

## Why `design.md` Is Optional, Not Required, but Recommended

The strict reading of "code is part of the SSoT" says `design.md` is redundant: the code shows _what_ was built, the rationales show _why_, and an architectural overview can be regenerated from code on demand. A purist setup needs only `README.md` and `rationales.md`.

But there is one argument strong enough to make `design.md` the **default-on** choice in `/rat-init`, even though it remains optional: **a good `design.md` is a map for the AI agent, and a good map saves context.**

When an agent is asked to make a change, it does not know up front which files matter. Without guidance it searches — listing directories, reading files, following imports — and each read costs context budget. On a non-trivial repo, the agent can burn through its window just _finding_ the code, before it has done any work. A `design.md` that opens with a clear, current **directory structure** — a tree of top-level folders with one-line descriptions of what lives where — short-circuits that search. Context is the constraining resource of AI-assisted development; a map is one of the cheapest ways to defend it.

A few corollaries follow:

- **The map must be at the top, terse, and current.** One line per folder; longer descriptions live below or in linked sections. A map that no longer matches the layout is worse than no map — the agent will follow it confidently into the wrong place. Map drift, like rationale drift, is a defect.
- **Architectural narrative is welcome below the map**, but it is the map itself that earns `design.md` its place by default.
- **Newcomer-onboarding is a real bonus**, but the AI-specific argument is what carries the recommendation. A user who does not pair with an agent, or whose project is small enough that the agent sees the whole tree at a glance, can reasonably opt out.

So the rule is: `design.md` is **optional** by philosophy (the SSoT does not require it), **recommended** by default (because most modern Rat-Coding work is AI-paired), and **the user's call** in any given project. This follows the more general principle:

> Rat-Coding was made for the user, not the user for Rat-Coding.

A methodology that overrides the user's judgment in the name of philosophical consistency has stopped being a tool and started being a creed. Rat-Coding picks the tool side of that line: the philosophy informs the defaults, but the user is always allowed to say "not this time."
