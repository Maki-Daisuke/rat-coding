---
name: rat-init
description: 'Bootstrap a Rat-Coding project after the user installs only /rat-init: install or merge the project-visible AGENTS.md rules, check/install the rest of the Rat-Coding skills with the user-approved skill manager, reload the rules, then hold a short Socratic dialogue to scaffold README.md and doc/rationales.md when needed. Use when the user runs /rat-init, asks to start a Rat-Coding project, asks to adopt Rat-Coding in a repo, or asks to bootstrap docs for a fresh repo. Architecture/framework selection and project initialization are handled by /rat-architecture.'
license: MIT
---

# /rat-init — Bootstrap a Rat-Coding Project

## What this skill does

`/rat-init` adopts Rat-Coding in the current repository after the user has installed only the `/rat-init` skill through a standard Agent Skills manager (`gh skill`, `npx skills`, APM, etc.). It installs or merges the project-visible rules, checks and offers to install the rest of the Rat-Coding skills, reloads the rules, then holds a short Socratic dialogue and scaffolds the project truth files when missing.

Files it touches:

- `AGENTS.md` at the repo root — the always-on rules that make the agent read and act on the project's rationales.
- `README.md` at the repo root — the project's press release (scaffolded when missing).
- `doc/rationales.md` — seeded with one entry: **"Why this project exists"** (scaffolded when missing).

See [_Why /rat-init Installs Rules Before Scaffolding Docs_](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-rat-init-installs-rules-before-scaffolding-docs) for the design rationale.

## Procedure

### 1. Inspect and protect existing files

Before writing anything, check whether these paths already exist in the repo root:

- `AGENTS.md`
- `README.md`
- `doc/rationales.md`
- `doc/design.md`

Rat-Coding is opt-in at every step. Never overwrite or merge without explicit user approval; if approval is denied or unclear, stop without changing the file.

- If `AGENTS.md` already exists with different content, ask whether to merge. On approval, preserve the existing file and place Rat-Coding's rules in a clearly marked managed block (`BEGIN RAT-CODING AGENTS` / `END RAT-CODING AGENTS`).
- If `README.md` or `doc/rationales.md` already exists, do not overwrite. Ask whether to keep it, adapt it in a later rationale-guided pass, or explicitly overwrite.
- Only `/rat-init` is required at entry — do not block `AGENTS.md` installation on the rest of the skill set.
- If the user only wants to adopt the runtime in a project whose docs already exist, install or merge `AGENTS.md`, check/install the skills, reload, and stop after reporting what was placed.

### 2. Install the Rat-Coding rules

Write `./AGENTS.md` from this skill's `assets/AGENTS.md`, applying the merge rules from step 1 if the file already exists.

### 3. Check and install the remaining Rat-Coding skills

After `AGENTS.md` is installed or merged, check whether the remaining Rat-Coding skills are installed in the current agent runtime. At minimum, inspect obvious local skill locations when they exist:

- `.agents/skills/`
- `.claude/skills/`

The expected public skills are:

- `rat-feature`
- `rat-architecture`
- `rat-audit`
- `rat-compaction`

If all expected skills are present, report that and continue.

If any are missing, follow this sequence:

1. Report the missing skill names and recommend installing them now.
2. Ask whether the user wants to install the missing skills. Stop this skill-install step if approval is denied or unclear.
3. Detect the skill manager by inspecting the project for these markers, in order:
   1. **APM** — `apm.lock.yaml` (and usually `apm.yml`) at the repo root.
   2. **`npx skills`** — `skills-lock.json` or `.skills.json` at the repo root.
   3. **`gh skill`** — any installed `**/SKILL.md` whose frontmatter contains `metadata.github-repo`, `metadata.github-ref`, or `metadata.github-tree-sha` (the Portable Provenance keys `gh skill` injects on install).
   4. **None of the above** — ask the user which manager to use. Do not guess.
4. Use the selected manager to install the missing skills from `Maki-Daisuke/rat-coding`. Per-manager invocation:
   - APM: `apm install Maki-Daisuke/rat-coding --skill rat-feature` (repeat `--skill` per skill).
   - `npx skills`: `npx skills add Maki-Daisuke/rat-coding --skill rat-feature` (repeat `--skill` per skill).
   - `gh skill`: `gh skill install Maki-Daisuke/rat-coding rat-feature` (one invocation per skill).

Keep the install project-scoped or runtime-scoped according to the selected manager's normal behavior; do not install Rat-Coding rules user-wide.

### 4. Reload `AGENTS.md`

After `AGENTS.md` is written or merged, reload it for the current session before continuing. If the agent runtime provides an explicit reload command, use it. Otherwise, read the resulting `AGENTS.md` into context and explicitly follow it for the rest of the session. If the editor only applies newly created `AGENTS.md` files to new chats or after a window reload, tell the user that and continue by following the file manually in this session.

### 5. Hold the dialogue

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

### 6. Decide on `doc/design.md`

Ask once whether the user wants `doc/design.md` scaffolded as well. **Default to yes.** A `design.md` that includes the project's directory structure functions as a map the agent uses to navigate the codebase in future sessions, and a good map is one of the cheapest ways to save context budget.

If the user declines, respect that — `design.md` is optional, not required. But the recommendation stands: most projects benefit from having one.

If scaffolded, the template should include at minimum:

- A short paragraph naming what the document is for (a map of the code, not a re-statement of `rationales.md`).
- A **directory structure** section — a tree of top-level folders with one-line descriptions of what lives where. Even at scaffold time, with mostly empty folders, this section primes future sessions to extend it as code is added.
- Placeholder headings for "Architecture overview" and "Key modules" that the user can fill in over time.

See [_Why `design.md` Is Optional, Not Required, but Recommended_](https://github.com/Maki-Daisuke/rat-coding/blob/main/doc/rationales.md#why-designmd-is-optional-not-required-but-recommended) for the rationale.

### 7. Scaffold the project truth files

Read the templates from this skill's Agent Skills `assets/` directory:

- `assets/README.md.tmpl`
- `assets/rationales.md.tmpl`
- `assets/design.md.tmpl` (only if the user said yes in step 6)

Each template uses `{{placeholder}}` markers. Fill them in from the dialogue. Do **not** invent content the user did not say; if a placeholder cannot be filled honestly, leave a short `TODO:` line that names what is missing. A `TODO` is a much better outcome than fabricated rationale.

The `design.md` directory structure section should reflect what actually exists at scaffold time. If the repository is mostly empty, start with a minimal tree and explicit `TODO:` markers; that map will evolve with the code.

Write the filled files to:

- `./README.md`
- `./doc/rationales.md`
- `./doc/design.md` (only if the user said yes in step 6)


### 8. Hand the keyboard back

End the skill with a short message that:

- Tells the user whether `AGENTS.md` was installed or merged, whether missing Rat-Coding skills were installed or left for later, and which project truth files were created.
- Names any `TODO:` markers that were left, and why.
- Reminds the user that **the project is "set up" the moment the first real _why_ is written down** — which it now is — and that further rationales accumulate as decisions are made, one at a time.
- If the user wants architecture/framework selection and project initialization next, point them to `/rat-architecture`.

Do **not** suggest next features, propose a roadmap, or otherwise drift into building. The skill's job ends here.

## What you must not do

- **Do not skip the dialogue.** Even if the user says "just scaffold it," push back once: an unscaffolded blank `README.md` is better than a fabricated one.
- **Do not invent rationale content.** If the user did not say it, do not write it. Leave a `TODO:` instead.
- **Do not decide architecture/frameworks or run init commands here.** That workflow belongs to `/rat-architecture`.
- **Do not install Rat-Coding user-wide, copy skill directories by hand, or run shell installers.** Skill installation goes through a standard skill manager with explicit user approval; Rat-Coding adoption must stay visible in the project.
- **Do not declare the project "complete" beyond what the user has actually decided.** The first rationale is a starting line, not a finish line.
