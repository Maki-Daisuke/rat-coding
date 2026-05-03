---
name: rat-init
description: 'Bootstrap a new Rat-Coding project by holding a short Socratic dialogue with the user about what they want to build, why, for whom, and what alternatives exist — and then scaffolding README.md and doc/rationales.md (with the first rationale "Why this project exists" already filled in from the conversation). Use when the user runs /rat-init, asks to start a new Rat-Coding project, or asks to bootstrap docs for a fresh repo. Architecture/framework selection and project initialization are handled by /rat-architecture. Does NOT install Rat-Coding itself; AGENTS.md and skills are assumed to already be present.'
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

### 3. Decide on `doc/design.md`

Ask once whether the user wants `doc/design.md` scaffolded as well. **Default to yes.** A `design.md` that includes the project's directory structure functions as a map the agent uses to navigate the codebase in future sessions, and a good map is one of the cheapest ways to save context budget.

If the user declines, respect that — `design.md` is optional, not required. But the recommendation stands: most projects benefit from having one.

If scaffolded, the template should include at minimum:

- A short paragraph naming what the document is for (a map of the code, not a re-statement of `rationales.md`).
- A **directory structure** section — a tree of top-level folders with one-line descriptions of what lives where. Even at scaffold time, with mostly empty folders, this section primes future sessions to extend it as code is added.
- Placeholder headings for "Architecture overview" and "Key modules" that the user can fill in over time.

See [_Why `design.md` Is Optional, Not Required, but Recommended_](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-designmd-is-optional-not-required-but-recommended) for the rationale.

### 4. Scaffold the files

Read the templates from this skill directory:

- `templates/README.md.tmpl`
- `templates/rationales.md.tmpl`
- `templates/design.md.tmpl` (only if the user said yes in step 3)

Each template uses `{{placeholder}}` markers. Fill them in from the dialogue. Do **not** invent content the user did not say; if a placeholder cannot be filled honestly, leave a short `TODO:` line that names what is missing. A `TODO` is a much better outcome than fabricated rationale.

The `design.md` directory structure section should reflect what actually exists at scaffold time. If the repository is mostly empty, start with a minimal tree and explicit `TODO:` markers; that map will evolve with the code.

Write the filled files to:

- `./README.md`
- `./doc/rationales.md`
- `./doc/design.md` (only if the user said yes in step 3)


### 5. Hand the keyboard back

End the skill with a short message that:

- Tells the user which files were created.
- Names any `TODO:` markers that were left, and why.
- Reminds the user that **the project is "set up" the moment the first real _why_ is written down** — which it now is — and that further rationales accumulate as decisions are made, one at a time.
- If the user wants architecture/framework selection and project initialization next, point them to `/rat-architecture`.

Do **not** suggest next features, propose a roadmap, or otherwise drift into building. The skill's job ends here.

## What you must not do

- **Do not skip the dialogue.** Even if the user says "just scaffold it," push back once: an unscaffolded blank `README.md` is better than a fabricated one.
- **Do not invent rationale content.** If the user did not say it, do not write it. Leave a `TODO:` instead.
- **Do not decide architecture/frameworks here.** That workflow belongs to `/rat-architecture`.
- **Do not run project initialization commands here.** This skill only bootstraps Rat-Coding docs.
- **Do not place `AGENTS.md` or other Rat-Coding files.** Those are install-time concerns, not bootstrap-time concerns.
- **Do not silently overwrite existing files.** Always ask.
- **Do not declare the project "complete" or "set up" beyond what the user has actually decided.** The first rationale is a starting line, not a finish line.
