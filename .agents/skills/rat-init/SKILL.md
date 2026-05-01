---
name: rat-init
description: 'Bootstrap a new Rat-Coding project by holding a short Socratic dialogue with the user about what they want to build, why, for whom, and what alternatives exist — and then scaffolding README.md and doc/rationales.md (with the first rationale "Why this project exists" already filled in from the conversation). Use when the user runs /rat-init, asks to start a new Rat-Coding project, or asks to bootstrap docs for a fresh repo. Does NOT install Rat-Coding itself; AGENTS.md and skills are assumed to already be present.'
license: MIT
---

# /rat-init — Bootstrap a Rat-Coding Project

## What this skill does

`/rat-init` starts a new Rat-Coding project in the current repository by holding a short, structured dialogue with the user, then scaffolding two files from the dialogue's content:

- `README.md` at the repo root — the project's press release.
- `doc/rationales.md` — seeded with one entry: **"Why this project exists"**.

It does **not** install Rat-Coding itself, place `AGENTS.md`, or copy other skills. By the time this skill runs, those are already present (that is what makes the slash command available).

See [_Why /rat-init Is a Dialogue, Not a Template Drop_](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-rat-init-is-a-dialogue-not-a-template-drop) for the design rationale.

## Procedure

### 1. Refuse to overwrite

Before anything else, check whether `README.md` or `doc/rationales.md` already exist in the repo root.

- If **either** exists, stop and tell the user. Ask whether they want to:
  - cancel, or
  - proceed and overwrite (destructive — confirm explicitly).

Never silently overwrite. Rat-Coding is opt-in at every step.

### 2. Hold the dialogue

Ask the following, **one at a time**, listening to the answer before moving on. Do not bundle them into a form. The point is the conversation, not the questionnaire.

1. **What do you want to build?** Get a one- or two-sentence sketch.
2. **What problem does this solve?** Push gently for specifics: who has this problem, what do they currently do about it, what's wrong with the current options.
3. **Why is _now_ the right time to build this?** Has something changed (tooling, constraints, evidence) that makes this newly viable or newly worth doing?
4. **What already exists in this space?** _You_ — the agent — should investigate at this step. Search for existing tools, libraries, services, or compositions of tools the user already has that solve some or all of this problem. Surface them honestly. Then ask:
   - Could one of these be the answer instead?
   - Could the user achieve their goal by composing existing tools?
   - Is the new thing actually a thin layer on top of an existing thing?

   The strongest rationale is often the rationale for **not building**. Surface that option clearly, even if the user came in wanting to build.

5. **What is _explicitly out of scope_** for the first version? What would you deliberately _not_ build?

Keep the dialogue short when the user already knows what they want. **Slow down — and switch into exploration mode — when the user is uncertain.** Uncertainty is not a problem to be hurried past; in Rat-Coding it is the most important state this skill operates in.

When the user is unsure, your job is **not** to extract a pre-formed answer that isn't there. It is to help them discover, through dialogue, the shape of the thing they actually want. Treat it as a search, conducted together:

- Ask follow-ups that test the edges: "What would make this _wrong_?", "If you had this tomorrow, who would be the first person you'd show it to, and what would you show them?", "What's the smallest version that would still feel worth doing?"
- Reflect what you're hearing back in your own words and ask if you got it right. The act of correcting your summary is often where the user finds clarity.
- Surface adjacent shapes the user might not have considered: "It sounds like this could be either X or Y — which one feels closer?"
- It is fine — sometimes correct — to end the dialogue with **"we don't know yet."** A `TODO:` rationale that honestly names the open question is more valuable than an invented answer that will mislead every future session.

Rat-Coding treats development as an **exploratory activity**: the product, the maker's understanding of the product, and the user's needs all grow together through the iteration. `/rat-init` is the very first turn of that loop. It does not need to converge on certainty; it needs to write down honestly what is known, what is unknown, and what the next question is.

### 3. Decide _how_ to build it — also a dialogue

Implementation choices (language, runtime, framework, key libraries, packaging story) are themselves rationale-worthy decisions. Do not pick silently, and do not ask the user to pick blind.

Hold a short follow-up dialogue:

1. **Ask first what the user already has in mind.** They may have a strong preference (existing team, existing toolchain, prior art). If so, your job is to sanity-check it against the project's shape from step 2, not to second-guess it.
2. **If the user is open or unsure, _make a recommendation_.** Look at what was decided in step 2 — the problem shape, who uses it, what surface it lives on (CLI? library? web service? desktop app?), what existing tools it composes with — and propose a stack that fits. Examples of factors to weigh:
   - **Surface fit**: a CLI for developers leans toward Go / Rust / Node; a quick internal tool leans toward Python; a browser-first thing leans toward TypeScript.
   - **Distribution**: needs single-binary distribution? → Go, Rust. Fine with `npm install`? → Node. Fine with `pip install`? → Python.
   - **Ecosystem**: is the bulk of the work calling an existing SDK that only has good support in one language? Follow the SDK.
   - **The user's existing skill set and preferences**, when you know them.
3. **Surface 2–3 plausible options, not just one.** State the trade-offs honestly: "X is faster to ship, Y is easier to distribute, Z matches the rest of your stack." Recommend one as the default and say why.
4. **Get an explicit decision from the user before continuing.** "Going with Go for the CLI, single binary distribution — yes?" If the user defers ("you pick"), make the call and record _why_ in the rationale.
5. **Capture the chosen stack as part of the first rationale entry**, under its own subsection (e.g. _"Why we chose &lt;language/framework&gt;"_), including the alternatives that were considered and rejected. Future sessions need to see that this was a deliberate decision, not a default.

If the project is too early for this question (e.g. it might be a shell script, or it might be a Rust crate, and the user genuinely doesn't know yet), it is fine to leave a `TODO:` in the rationale and defer. Do not force a decision the user is not ready to make.

### 4. Initialize the project with the stack's standard tooling

Once the stack is chosen, propose initializing the project with whatever the chosen ecosystem considers idiomatic. **Always ask before running anything** — commands at this step create files, run network installs, and pick a directory layout that the rest of the project will inherit. That is a decision, not an automatic step.

The goal is to follow the ecosystem's conventional layout so that future contributors (human or AI) find what they expect where they expect it. Some examples of what the standard initializer looks like, by stack:

- **Go**: `go mod init <module-path>`
- **Node / TypeScript library**: `npm init -y` (then `tsc --init` for TypeScript)
- **React (Vite)**: `npm create vite@latest <app-name> -- --template react` (or `react-ts`)
- **Next.js**: `npx create-next-app@latest <app-name>`
- **Python**: `uv init` (preferred) or `poetry new <name>` / `python -m venv .venv` + `pyproject.toml` by hand
- **Rust**: `cargo init` (existing dir) or `cargo new <name>` (new dir)
- **Deno**: `deno init`

This list is illustrative, not exhaustive. For any stack, the principle is the same: **use the canonical project initializer for that ecosystem**, not an ad-hoc layout invented by the agent.

Procedure:

1. State the exact command(s) you intend to run, with arguments filled in. Example: _"The standard way to start a Go module here is `go mod init github.com/<user>/<repo>`. Run it?"_
2. **Wait for explicit user approval before executing.** "Yes" / "go ahead" / "OK" is fine; silence is not.
3. If the initializer wants to scaffold into a subdirectory (some `create-*` commands do), check with the user whether that is what they want, or whether the project should live at the repo root.
4. After running, summarize what was created (files, directories, `package.json`, `go.mod`, etc.) so the user can see the new layout at a glance.
5. If the user declines, respect that. The project can live as plain files; some users prefer to set up tooling later or by hand.

If you do not know the conventional initializer for the chosen stack, **say so and ask the user** rather than guessing. An honest "I'm not sure what the standard initializer is for X — do you know which one you'd like to use?" is better than running the wrong command.

### 5. Decide on `doc/design.md`

Ask once whether the user wants `doc/design.md` scaffolded as well. **Default to yes.** A `design.md` that includes the project's directory structure functions as a map the agent uses to navigate the codebase in future sessions, and a good map is one of the cheapest ways to save context budget.

If the user declines, respect that — `design.md` is optional, not required. But the recommendation stands: most projects benefit from having one.

If scaffolded, the template should include at minimum:

- A short paragraph naming what the document is for (a map of the code, not a re-statement of `rationales.md`).
- A **directory structure** section — a tree of top-level folders with one-line descriptions of what lives where. Even at scaffold time, with mostly empty folders, this section primes future sessions to extend it as code is added.
- Placeholder headings for "Architecture overview" and "Key modules" that the user can fill in over time.

See [_Why `design.md` Is Optional, Not Required, but Recommended_](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-designmd-is-optional-not-required-but-recommended) for the rationale.

### 6. Scaffold the files

Read the templates from this skill directory:

- `templates/README.md.tmpl`
- `templates/rationales.md.tmpl`
- `templates/design.md.tmpl` (only if the user said yes in step 5)

Each template uses `{{placeholder}}` markers. Fill them in from the dialogue. Do **not** invent content the user did not say; if a placeholder cannot be filled honestly, leave a short `TODO:` line that names what is missing. A `TODO` is a much better outcome than fabricated rationale.

If the project was initialized in step 4, the `design.md` directory structure section can now reflect the **actual** layout the initializer produced — fill it in from what's on disk, not from imagination. If step 4 was skipped, the directory tree starts mostly as `TODO:` and grows alongside the code.

Write the filled files to:

- `./README.md`
- `./doc/rationales.md`
- `./doc/design.md` (only if the user said yes in step 5)


### 7. Hand the keyboard back

End the skill with a short message that:

- Tells the user which files were created.
- Names any `TODO:` markers that were left, and why.
- Reminds the user that **the project is "set up" the moment the first real _why_ is written down** — which it now is — and that further rationales accumulate as decisions are made, one at a time.

Do **not** suggest next features, propose a roadmap, or otherwise drift into building. The skill's job ends here.

## What you must not do

- **Do not skip the dialogue.** Even if the user says "just scaffold it," push back once: an unscaffolded blank `README.md` is better than a fabricated one.
- **Do not invent rationale content.** If the user did not say it, do not write it. Leave a `TODO:` instead.
- **Do not pick the implementation stack silently.** Either the user picked it, or you recommended and the user agreed — never "the agent just chose Python because Python." The chosen stack is rationale; record it.
- **Do not refuse to recommend.** If the user is unsure about the stack, _propose_ — with trade-offs and a default. Hiding behind "it's up to you" is not neutrality, it is abdication.
- **Do not run project-init commands without explicit approval.** `go mod init`, `npm create`, `cargo new`, etc. all create files and pick layouts; state the command, wait for the user to say go, then run.
- **Do not invent a non-standard project layout** when a conventional initializer exists for the chosen stack. Use the ecosystem's canonical tool; if you don't know it, ask.
- **Do not place `AGENTS.md` or other Rat-Coding files.** Those are install-time concerns, not bootstrap-time concerns.
- **Do not silently overwrite existing files.** Always ask.
- **Do not declare the project "complete" or "set up" beyond what the user has actually decided.** The first rationale is a starting line, not a finish line.
