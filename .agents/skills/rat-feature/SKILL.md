---
name: rat-feature
description: "Add a new feature the Rat-Coding way: dialogue about why and how, check the feature against the product's press release, surface security risks and alternatives, write the rationale (why + chosen implementation approach) before coding, then iterate — rationale → implement → discover → update rationale → implement — until the ideal is realized. Use when the user runs /rat-feature or proposes any non-trivial change. Assumes README.md and doc/rationales.md already exist."
license: MIT
---

# /rat-feature — Add a Feature, the Rat-Coding Way

## What this skill does

`/rat-feature` is the structured turn that happens when, in an existing Rat-Coding project, the user proposes adding something new — a feature, a command, an option, a new module. It enacts the [_Before starting anything new_](https://github.com/Maki-Daisuke/rat-coding/blob/main/AGENTS.md) clause of `AGENTS.md` as a concrete, repeatable workflow:

1. Re-load the project's current truth (`README.md`, `doc/rationales.md`, `doc/design.md` if present).
2. Hold a short dialogue about **why** this feature, **why now**, **whether it serves the product's press-release vision**, and **why build it instead of compose / extend / not build** — including any security risks.
3. Cross-check against existing rationales for conflicts or staleness.
4. Decide **how** to build it — also a dialogue. Non-trivial implementation choices are rationale-worthy decisions and get written down alongside the why.
5. Capture both decisions — _why_ and _how_ — as a **new rationale entry** in `doc/rationales.md` _before_ writing code.
6. **Iterate**: implement → surface discoveries → update rationale → implement again, until the ideal and the reality converge.
7. Close the loop: keep `README.md` / `doc/design.md` in sync with what was actually built.

Two non-negotiables: **the rationale comes before the code** — no honest rationale means not ready to build; and **the skill stays until the code works** — an unimplemented rationale is hollow, and the loop runs as many times as needed.

## When NOT to use this skill

`/rat-feature` is for **non-trivial** changes. Skip it for:

- Pure bug fixes (the rationale already exists; you're correcting drift, not deciding anything new).
- Typo fixes, formatting, lint cleanup, dependency bumps with no behavioral change.
- Mechanical refactors that preserve behavior and don't touch a documented design decision.

If the change crosses any of these lines, treat it as non-trivial and use this skill:

- Adds a new public surface (CLI command, flag, exported function, HTTP endpoint, config key).
- Changes behavior a user could observe.
- Touches a decision that is recorded in `rationales.md`, or _should_ be recorded there.
- Introduces a new dependency, new language/runtime, or new architectural layer.
- Removes or deprecates anything.

When in doubt, use the skill. The cost of an extra paragraph in `rationales.md` is small; the cost of a silently overturned past decision is large.

## Procedure

### 1. Re-load the project's truth

Before asking the user anything, read — in parallel where possible:

- `README.md` (the press release: what this product is _for_).
- `doc/rationales.md` (the runtime spec: every "why" already on the record).
- `doc/design.md` if it exists (the map: where things live).

If any of these are missing, this is probably not a Rat-Coding project yet. Stop and tell the user; suggest `/rat-init` if appropriate. Do not invent rationales for a project that has none.

While reading, note rationales that **could be touched** by the request (related ground, adjacent decisions, things deliberately _not_ built), and the relevant codebase shape from `design.md` if available.

### 2. Hold the dialogue

Ask the following, **one at a time**, listening to the answer before moving on. Do not bundle them into a form. The point is the conversation, not the questionnaire.

1. **What do you want to add?** Get a one- or two-sentence sketch, then immediately hold it against the `README.md` press release. Does it serve the product's stated purpose? If not, surface the tension: _"This looks outside the product's scope — is the press release outdated, or is this feature out of scope?"_ A mismatch is a reason to update the identity or drop the feature, never to build past it silently.
2. **What problem does this solve?** Push gently for specifics: who currently feels the lack of this, what do they do today instead, what's wrong with that.
3. **Why _now_?** Has something changed (new tooling, new evidence, new constraint, accumulated friction) that makes this newly worth doing? "Why now" often distinguishes a real need from a passing impulse.
4. **What already exists in this space?** _You_ — the agent — should investigate at this step. Two layers of investigation:
   - **Inside this repo.** Is there an existing module, command, or function that could be _extended_ to cover this need with a smaller change? `design.md`'s map and the rationales' record of past decisions are your starting points.
   - **Outside this repo.** Is there an existing library, tool, or service that solves some or all of this problem? Could the user achieve the goal by composing tools they already have?

   Surface what you find honestly. Then ask:
   - Could one of these be the answer instead of new code in this repo?
   - Is the proposed feature actually a thin wrapper around something that already exists?
   - Is there a smaller change to existing code that captures most of the value?
   - **Does this feature introduce a security risk?** Even if the user wants it, a feature that opens a vulnerability — injection surface, excessive privilege, exposed sensitive data, denial-of-service vector — can harm the user more than the missing feature hurts them. If a credible security risk exists, name it explicitly as a reason not to build (or to build differently), and do not let enthusiasm for the feature paper over it.

   The strongest rationale is often the rationale for **not building** — or for **building less** or **building differently to stay safe**. Surface those options clearly, even if the user came in wanting to build the full thing.

5. **What is _explicitly out of scope_** for this feature? What would you deliberately _not_ do, even though it might look adjacent? Explicit non-goals are how future sessions know the boundary.

Keep the dialogue short when the user is clear and the alternatives are obviously worse. **Switch into exploration mode when the user is uncertain, or when an alternative looks credible.** When unsure, explore together rather than extract: test the edges ("what would make this wrong?"), reflect back what you heard, offer adjacent shapes ("could this be X or Y?"). It is fine — sometimes correct — to end with **"we don't know yet."** A `TODO:` naming the open question beats a fabricated rationale.

### 3. Cross-check against existing rationales

Before agreeing to write anything, verify the proposed feature against the rationales you loaded in step 1.

For each candidate rationale you flagged as "potentially touched":

- **Does the proposal _conflict_ with this rationale?** If so, stop and surface the conflict to the user. Do not silently override past decisions, and do not silently conform to them either. Ask:
  - Which one is wrong — the past rationale, or the proposed direction?
  - If the past rationale is wrong, _why_? Have the premises changed (new tooling, new constraints, new evidence), or was the past decision itself a mistake that needs implementation-level correction?
- **Does the proposal _depend on_ this rationale?** If so, check whether the rationale's premises still hold. Rationales are not commandments — they are the project's current best understanding. If the premise is stale, surface that too.

Possible outcomes of this check:

- **No conflict.** Continue.
- **Conflict, past rationale wins.** The new proposal is dropped or reshaped. Record the consideration briefly in the new rationale entry ("we did not do X because of [past rationale]") so the question doesn't get re-asked next session.
- **Conflict, new direction wins.** The past rationale is being **overturned**. Treat this as a [multi-file change](https://github.com/Maki-Daisuke/rat-coding/blob/main/AGENTS.md): in the same change set, propose updating `doc/rationales.md` (revising the old entry _and_ adding the new), and any of `README.md` / `doc/design.md` / the implementation that the reversal touches. Be conservative about reversal; be diligent when reversal is warranted.

### 4. Decide _how_ to build it — also a dialogue

Why and How are both rationale-worthy. Do not treat implementation choices — a new dependency, module shape, where the feature plugs in, public-API naming, an architectural pattern — as purely technical details to be decided silently. Give them the same Socratic treatment as the Why:

1. **Ask first what the user already has in mind.** They may have a strong preference (existing conventions, team familiarity, prior art). If so, your job is to sanity-check it against the feature's shape and the project's existing rationales, not to second-guess it.
2. **If the user is open or unsure, _make a recommendation_.** Surface 2–3 plausible options with honest trade-offs. Recommend one as the default and say why. "Option A is simpler to implement but harder to extend; option B fits the existing abstraction better at the cost of a new dependency — I'd go with B because…"
3. **Get an explicit decision before continuing.** If the user defers ("you pick"), make the call and state _why_ — that reason becomes part of the rationale.
4. **Flag when the How decision is non-trivial.** A How decision is non-trivial when:
   - It introduces a new dependency, architectural layer, or packaging concern.
   - It defines a public surface (API shape, CLI flag spelling, config key) that will be hard to change later.
   - It departs from patterns already established in the codebase.
   - It has security implications of its own (e.g. choosing how to handle untrusted input, where secrets are stored).

   Non-trivial How decisions get their **own subsection** in the rationale entry — or, when the decision is significant enough to stand alone, their **own entry** in `doc/rationales.md`. The test: would a future session benefit from knowing why this approach was chosen over the alternatives? If yes, write it down.

For small features where the How is obvious ("add a flag to the existing command"), a single confirmatory sentence is enough. Scale the dialogue to the weight of the decision.

### 5. Write the rationale _before_ the code

Once the dialogue has produced both a Why and a How you can honestly state, propose a new entry (or entries) in `doc/rationales.md`. A single feature may produce one combined entry or two separate ones — use a separate entry when the How decision is significant enough to stand alone (see step 4). Either way, the content to capture:

- **Heading**: H2 or H3, phrased as a "why" — _"Why we added X"_, _"Why X is a flag on `foo` rather than its own command"_, _"Why we chose approach Y"_ — not a feature title.
- **Why**: the problem, who feels it, why now, and what was wrong with the status quo.
- **How and why that How**: the chosen implementation approach; the alternatives rejected (including "don't build" / "compose tools" / "extend existing module" / "build differently for safety"); any constraints that drove the choice.
- **Premises**: what must remain true for this decision to hold.
- **Non-goals**: explicit scope boundary from step 2.5.

Keep it short. A few paragraphs is usually right; pages are usually wrong. The file must stay [small enough to load every session](https://github.com/Maki-Daisuke/rat-coding/blob/main/AGENTS.md). If a section is growing out of hand, split or compress.

If the dialogue did not produce enough material to write the rationale honestly, **stop and say so**. Do not invent justification. A `TODO:` entry that names the open question is the right artifact in that case, and the implementation waits.

Show the proposed rationale entry to the user and **get explicit approval before writing it to `doc/rationales.md`**. Then write it. Treat this as a real edit to a real document, not boilerplate.

### 6. Plan the implementation, then ask before doing it

With the rationale on the record, propose an implementation plan:

- Which files will be created, edited, or deleted.
- The order of changes (smallest reviewable steps preferred).
- What tests / checks will validate the behavior.
- Any open questions that the rationale flagged as `TODO:`.

**Wait for explicit user approval before executing.** "Yes" / "go ahead" / "OK" is fine; silence is not. The user owns the final call; the skill never auto-runs the implementation.

### 7. Iterate: rationale → implement → discover → update → repeat

Rat-Coding is an exploratory, iterative process. Steps 5–7 are not a linear sequence you pass through once — they are a **loop** you run until the ideal meets the reality:

```
write rationale  →  implement  →  surface discoveries
       ↑                                   |
       └───────── update rationale ←───────┘
```

**The loop ends when the implementation realizes the rationale** — when what was decided as the ideal is now true in the running code. Until that moment, the work is not done.

**When a discovery surfaces during implementation:**

- **Stop and report.** Examples that matter: the library doesn't behave as expected, the API has changed, performance is materially off, a security risk becomes apparent, a constraint surfaces that no one knew about at decision time.
- **Do not paper over the discovery with a workaround or dirty hack.** That trades a small short-term gain for a much larger long-term cost — the rationale and the code start describing different worlds, and every future decision built on top will be subtly wrong.
- **Return to the rationale with the user.** A discovery is not a bug in the workflow — it is a turn in the dialogue. Together, choose one of two directions:
  - **Move the implementation toward the ideal.** The rationale stands; the code needs more work to realize it.
  - **Move the ideal toward reality.** The rationale was too ambitious, or rested on a false premise. Update it to reflect what is actually achievable — and what was learned — then continue implementation against the revised ideal.
- **Either way, the rationale gets updated** before the next implementation pass. A rationale that no longer matches what you are actually building is a bug.

Keep iterating — once, five times, however many it takes. Stopping with a rationale that has no working implementation behind it is not acceptable.

### 8. Close the loop: docs and code in sync

After the implementation lands, **re-read the affected sections** of `README.md`, `doc/rationales.md`, and `doc/design.md` (if present) and confirm they still describe what the code does:

- **`README.md`**: if the feature is user-visible, the press release may need a sentence updated. Do not add a kitchen-sink feature list — the README is still a press release, not a changelog.
- **`doc/rationales.md`**: the entry written in step 5 should still be accurate. If implementation discoveries (step 7) changed the picture, the entry should already have been updated — confirm it was.
- **`doc/design.md`**: if the directory layout changed, or a new module was introduced, update the map. A `design.md` whose map no longer matches the layout is worse than no map at all.

If anything is out of sync, propose the doc updates as part of this same change set, not later. Drift between docs and code is a defect.

### 9. Hand the keyboard back

End the skill with a short message that:

- Names what was decided (one-line summary of the rationale).
- Names what was implemented (files touched).
- Names any `TODO:` markers that were left, and why.
- Reminds the user that the feature's "why" is now durable — future sessions will see it.

Do **not** suggest the next feature, propose a roadmap, or otherwise drift into building. The skill's job ends here.

## What you must not do

- **Do not skip reading `doc/rationales.md`.** Acting without it is acting on guesswork.
- **Do not skip the dialogue.** A feature without a stated "why" is one future sessions cannot defend.
- **Do not silently contradict or blindly conform to a past rationale.** Surface conflicts and staleness explicitly (step 3).
- **Do not invent rationale content.** If the user did not say it, leave a `TODO:` instead.
- **Do not write code before the rationale is on the record.** Step 5 before step 6, always.
- **Do not pick semantically loaded implementation choices silently.** Either the user chose it, or you recommended and they agreed.
- **Do not auto-run the implementation.** State the plan, wait for approval, then execute.
- **Do not paper over discoveries or let docs drift.** Re-open the rationale; fix drift in the same change set.
- **Do not block the user with hard rules.** Flag problems and ask. The user owns the final call.
