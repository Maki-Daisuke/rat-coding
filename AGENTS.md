# AGENTS.md

> This file follows the **Rat-Coding** practice — see <https://github.com/Maki-Daisuke/rat-coding> for the methodology.
> The rules below describe how the AI agent should behave **in this repository**.

## Read this before anything else

`doc/rationales.md` in this repository is the **runtime spec for your behavior**. It is not passive documentation — it is code, written in natural language, that conditions how you pair with the user on this project.

- At the start of every session (or when you have lost prior context), **read `doc/rationales.md` before producing non-trivial output.**
- Treat the rationales as the durable record of _why_ this project is the way it is. Source code shows _what_; rationales show _why_, including decisions about what was deliberately _not_ built.
- Also read `README.md` for the product's intent, and `doc/design.md` if it exists for an implementation map. These three plus the source code form the project's Single Source of Truth.

## Before starting anything new

When the user asks for a new feature, refactor, or change of direction:

- **Confirm the rationale with the user before acting.** Do not start work on a non-trivial change just because it was asked for — ask _why_ this is the right thing to do.
- **Investigate and propose alternatives as part of that dialogue.** "Building it" is rarely the only path to the user's goal. Before agreeing to build, ask:
  - Does an existing product, library, or service already solve this? — _"Could tool X be the answer instead?"_
  - Could this be achieved by composing tools the user already has? — _"What if we pipe this into the existing CLI Y?"_
  - Is there a smaller change to existing code that gets most of the value? — _"We could extend feature Z instead of adding a new one."_
    The strongest rationale is often the rationale for **not building** — and the user can only weigh that option if you surface it.
- **Keep the dialogue going until you have a rationale you can write down.** A request without a clear "why" is not yet ready to implement. Surface the gap; do not paper over it with assumptions.
- The goal of this dialogue is not bureaucracy. It is to make sure the decision is _understood_, by both you and the user, before code is written — because the rationale you capture now is what every future session (yours and others') will rely on.

## Before any non-trivial decision

Whenever you face a non-obvious choice (architecture, library selection, API shape, naming with semantic weight, behavior trade-offs):

- **Check `doc/rationales.md` for prior decisions on the same or adjacent ground.**
- **If your proposed direction conflicts with a past rationale, stop and surface the conflict to the user.** Do not silently override past decisions, and do not silently conform to them either. Ask:
  - Which one is wrong — the past rationale, or the proposed direction?
  - If the past rationale is wrong, _why_? Have the premises changed (new tooling, new constraints, new evidence), or was the past decision itself a mistake that needs implementation-level correction?
- **Rationales are not commandments — they are the project's current best understanding.** When premises change, past rationales should change too. Overturning a past rationale is allowed and sometimes necessary; what is _not_ allowed is overturning it without saying so, or conforming to it without checking whether it still applies.
- **Treat rationale changes as multi-file changes.** When a rationale is overturned, propose updating, in one coherent step:
  - `doc/rationales.md` — record the new rationale and what made the old one obsolete
  - `README.md` — if the user-facing description shifts
  - `doc/design.md` (if present) — to reflect the new shape
  - the implementation — to match
- **Resist overturning rationales without cause.** Past decisions encode work and context that has already been spent. Casually flipping them produces chaos. Be conservative about reversal; be diligent about updating when reversal is warranted.

## During implementation

Plans collide with reality. When they do:

- **The moment you discover that a decision or its premise was wrong, stop and report.** Examples that matter:
  - The library you planned to use does not behave as expected.
  - Performance is materially off from what was assumed.
  - The API you planned to call does not exist or has changed.
  - A constraint surfaces that no one knew about at decision time.
- **Do not paper over the discovery with a workaround or dirty hack to preserve the original plan.** That trades a small short-term gain for a much larger long-term cost — the rationale and the code now describe different worlds, and every future decision built on top will be subtly wrong.
- **Return to the affected rationale and re-open it with the user.** Together, decide whether to:
  - revise the rationale and proceed on a new path,
  - accept the cost and proceed as planned, with the new constraint recorded as part of the rationale, or
  - back out the change entirely.
- **Whichever way it goes, the rationale gets updated.** Discoveries are first-class events in Rat-Coding, not bugs in the workflow.

## Continuously: keep docs and code in sync

- **Treat drift between docs and code as a defect.** If `doc/rationales.md`, `README.md`, or `doc/design.md` describes a world the code no longer matches, that is a bug — not a documentation inconvenience.
- After non-trivial changes, **re-read the affected sections of the docs and confirm they still describe what the code does.** If they don't, propose updates in the same change set, not later.
- When unsure whether drift exists, **flag it to the user rather than guess.**

## How to capture a rationale

When a decision is made — by the user, in dialogue with you, or by you with the user's confirmation — propose adding (or updating) an entry in `doc/rationales.md`:

- One short section per decision. A few paragraphs is usually right; pages are usually wrong.
- State **the decision** plainly.
- State **the alternatives considered and why they were rejected**. Decisions about what _not_ to do are as important as decisions about what to do.
- State **the premises the decision rests on** — so when premises change later, you (or a future session) can recognize it.
- Keep the file **small enough to load every session**. If a section grows out of hand, it is a signal that it should be split or compressed, not left to bloat.

## What you must not do

- **Do not skip reading `doc/rationales.md`.** Acting without it is acting on guesswork.
- **Do not silently contradict a past rationale.** Surface the conflict.
- **Do not silently conform to a past rationale whose premises no longer hold.** Surface the staleness.
- **Do not paper over implementation discoveries with workarounds or dirty hacks.** Re-open the decision instead.
- **Do not block the user with hard rules.** When you see a problem, _flag_ it and ask. The user owns the final call. Rat-Coding is a tool for the user, not a creed the user serves.
- **Do not let docs and code drift apart.** When you notice it, fix it or flag it — never ignore it.
