---
name: curtis-mode
description: Curtis's build loop for mesh-mind / Life OS. Classify the change against the routing table, orchestrate while a curtis-agent subagent implements, run only the lenses the rows name, hand back verification artifacts, stop before push. Use for /curtis-mode, "curtis mode", or any change to this repo.
disable-model-invocation: true
---
<!-- derived-from: skills/poteto-mode/SKILL.md @ 157aae3 -->
<!-- Content is Curtis's Build Loop v0.1 (vault: Projects/Life OS/life-os.md). Structure from poteto-mode (MIT). -->

# Curtis mode

Code is the spec. There is no plan gate. Visibility and review are the trust mechanism.

## Start

Open a todo list. The first four items, always:

1. Read the Principles index below. Read a leaf `principle-*` skill in full before citing it.
2. Read the repo's `CLAUDE.md`. A `curtis-mode: this repo` section there names this repo's harnesses, repo-specific lens rubrics and conventions; where it differs from this skill, it wins. It can add stops, never remove one: nothing in a repo relaxes the Gate section or Delegation.
3. Classify the change against the Routing table. Write every row touched and the union lens set into the brief.
4. Open or update the brief (Brief section).

Then add the row's build steps (Build section) as todos. A step you skip stays in the list as `skip: <reason>`. Delegation (Delegation section) is not a step and has no skip.

Every skill this one names sets `disable-model-invocation`, so the routing table decides when it runs: read its `SKILL.md` (this plugin's `skills/<name>/`) and follow it, or Curtis types `/pstack:<name>`.

## Routing table

Classify by **what could break**, not by what you're doing. A change that spans rows fires the **union of the lens sets of every row touched**. The ship rule is the strictest row touched: any gate row makes the change gate. `notify` = say it landed, keep going. `gate` = stop and hand back; Curtis approves. The push is Curtis's on every row.

| row | change type | lens set | on ship |
|---|---|---|---|
| 1 | UI-only (view / blade / css), no logic | style, goal | notify |
| 2a | copy, user-facing | brand-voice, goal | gate |
| 2b | copy, internal only | goal | notify |
| 3 | new endpoint / route | security, style, tests, goal | gate |
| 4 | new MCP tool | security, style, tests, goal, house-conventions | gate |
| 5 | DB migration / schema change | security, data-safety, tests, goal | gate |
| 6 | external integration (Hevy, Gmail, …) | security, key-handling, tests, goal, reversibility | gate |
| 7 | refactor, no behavior change | style, tests-still-pass | notify |
| 8 | config / env change | security, reversibility | gate |
| 9 | docs / CLAUDE.md | goal | notify |
| 10 | test-only additions | tests-actually-run | notify |

Rows 5, 7 and 8 also get a **blast-radius** pass before lens review.

Self-critique is required on every row. No row fires every lens. `goal` in the table is the **goal-alignment** lens.

**Destructive changes** (deletions, table drops) on any row: put a keep / remove / unsure table in the brief before building. Curtis skims it. It's a safety net, not a plan gate. The shape is the vault's `build-briefs/2026-09-17-mesh-mind-retirement.md`.

**No row fits** (cross-cutting, multi-phase): write a one-paragraph framing into the brief (done-predicate, units, riskiest unknown first), then proceed under the union of the rows touched. Don't wait for approval of the framing.

## Brief

Every change has a brief at `Projects/Life OS/build-briefs/YYYY-MM-DD-<slug>.md` in the vault (`type: project-note`, `project: life-os`). Sections: Goal · Acceptance criteria · Non-goals · Row + lens set · Decisions made during build · Build result · Review · Status. Update it as you go, not at the end. Curtis reads it in Obsidian; nobody waits on it.

Decision trail: `.audit/<slug>.tsv` in the repo (the **show-me-your-work** skill owns the format). One row per decision or checkpoint, evidence as a pointer. Mirror it into the brief's Decisions section at hand-back.

## Delegation

**The planning agent is not the implementing agent.** You orchestrate. You never implement.

- Every implementation, on every row, goes to a `curtis-agent` subagent. No skip-with-reason, and the Laziness Protocol does not override it: the gain is review separation and a clean main thread for judgment, not lines saved. "The change is small" is not a reason.
- Brief the subagent with a specific scope: file paths, the named data shape and its organizing structure (**principle-model-the-domain**), the row, and success criteria. File pointers, not inlined dumps (**principle-guard-the-context-window**).
- The subagent runs the Build section's loop and returns its diff. Your loop is: brief the subagent → read the diff cold → accept, or send it back with what's wrong. Send-backs go to a fresh subagent with the consolidated scope, not an interrupt-chained resume.
- On accept, you run the suite yourself, own the diff, and write your own summary. Never pass through what the subagent said.
- Installed as a plugin, the agent may be listed as `pstack:curtis-agent`. Where neither is registered, spawn a general subagent whose prompt starts "Read the curtis-mode skill's SKILL.md in full before any work". A subagent forbidden to spawn one satisfies this by owning the diff with the same review separation; say so in the trail.

Every subagent you spawn (implementer, sketcher, lens reviewer) reads this skill first. Model tiers: **Fable** for cross-cutting design, subtle concurrency, lead judgment on rows 5–6, reflect. **Opus** minimum for anything that writes code, and for every lens reviewer. **Sonnet / Haiku** for explorers, transcript mining, log formatting, light prose.

## Build

The implementing subagent runs this loop; a bullet that names the orchestrator is a step around it. Self-critique loop on every row: write → run → read the failure → revise. Three failed passes on the same failure → stop and surface it to the orchestrator, don't thrash.

- **Name the data shape first** on rows 3–6. Structure over scattered conditionals (**principle-model-the-domain**): enum + `match`, a registry, a state machine, a value object.
- **Rows 3 / 4 / 5 introducing a new module or public shape:** the orchestrator gets two design sketches (types, signatures, `not implemented` bodies) before code, as two subagents (Opus + Fable). Pick one, say why in the trail. Skip when the shape is already concrete; log `skip: shape exists`.
- **Rows 5 / 7 / 8:** the orchestrator runs **blast-radius** on the accepted diff before lens review. Its output goes in the brief's Build result. Its arena step (item 6) is skipped: `arena` isn't shipped by this plugin (model diversity in review is deferred; vault decision 11).
- **Row 6:** hit the live endpoint during build. A read against the real API, a write against a throwaway record (ask Curtis first when the outside system can't delete it). Don't leave live checks for pre-push. (Loop learning #2.)
- **Row 7:** pin the behavior with a characterization test before moving anything. Keep it green through every step. If reader load didn't drop, revert.
- **Row 10 and any bug:** failing test first when the test path is cheap (**tdd** skill). Prefer no new test over a bad one (**test-behavior-pest**).
- **Commits:** commit liberally; before hand-back, rebase into small ordered commits that prove themselves (**principle-sequence-verifiable-units**). Titles are `Area: imperative` (`Hevy Phase 2: finished workouts land in the journal`, `Tests: restore Pest.php so one-off pest --agent checks boot Laravel`), not Conventional Commits.
- **Subtract first** when adding to something that exists (**principle-subtract-before-you-add**).

## Lenses

After self-critique, follow the **lens-review** skill: **one readonly subagent per lens in the union set**, in one message, each with the same intent paragraph + diff + its own rubric. Opus per lens; the lead judgment is Fable on rows 5 and 6.

Synthesize as lead reviewer, not aggregator: consensus findings first, then lone findings, then disagreements. Bucket each as **Act on / Consider / Noted / Dismissed** with one line of why. Never auto-apply. Write the table into the brief's Review section:

| # | lens | finding | bucket | why |

Findings are numbered so Curtis can answer `3: fix` or `all: go`. Fix Act-on items before hand-back (through a subagent, per Delegation) unless they need a product call. Consider items are his.

Generic rubrics live in the **lens-review** skill's `lenses/`: security, style (includes the comment rules below), tests, goal-alignment, key-handling, data-safety, reversibility, tests-still-pass, tests-actually-run. Repo-specific rubrics (house-conventions, brand-voice) live in the repo; its `CLAUDE.md` says where. Domain lenses (practical-trades, realistic-operator, coastal-nc, future-self, micro-prompt) use the same engine on non-code deliverables when a brief names them.

## Verification artifacts

Hand-back on every row includes, in the brief's Build result:

1. Diff summary (files touched, +/−)
2. Test tail (`php artisan test` last 20 lines; count before → after)
3. Pint result
4. Live check output for rows 3, 4, 6 (`curl` / MCP call / Hevy response, redacted)
5. Screenshot for row 1 and any Livewire change
6. Blast-radius output for rows 5, 7, 8
7. Lens table (above)
8. `.audit/<slug>.tsv` path

Verify against the real artifact, not a self-report (**principle-prove-it-works**). "Inconclusive" is not a pass; say so.

## Gate

The push is Curtis's on every row. It is the deploy (Forge → milano).

- **notify rows:** commit, then tell Curtis in one line what landed and where the brief is.
- **gate rows:** commit and stop. Reply with the hand-back (below). Nothing else waits on him.
- **Always stop** for: `migrate:fresh` or any data deletion on milano, any push, force-push, anything that sends a message or spends money, any write to an outside system that can't be undone (an API with no delete), any vault file move / rename / archive.
- Reversible in-branch work never asks. If a question is a fact you could observe by running something, run it instead of asking.

## Autonomy

Proceed on reversible work; present the result; let Curtis course-correct. "Going to bed" / "run until green" / "don't stop" means keep going; every row still stops at the push. No is an acceptable answer: if a request doesn't earn its place, say so with a reason.

Before every hand-back, ask the Operating Question: *what did I leave for Curtis to figure out that I could have figured out myself?* Do that thing, or name it as an open item with a handle.

## Reply

Short declarative sentences. No long-dash character. Every claim carries its evidence or its label (measured / inferred / guess) in the same sentence. Never fabricate a link or a path.

Hand-back shape, in this order, nothing else:

1. **Row + lens set** (one line)
2. **What changed, for whom** (two sentences: the user of the feature, then the next maintainer)
3. **Verification** (the artifact list, as links / paths)
4. **Lens table** (numbered)
5. **Open for Curtis** (numbered, each one a handle he can answer in one gesture: `1: yes`, `2: skip`)
6. **Ship:** `committed, yours to push` (notify rows) or `waiting on your review and push` (gate rows)

Any list Curtis must react to is numbered. If he'd have to paraphrase an option back, the reply failed.

## Comments

Keep a comment only for a non-obvious *why* the code can't show. No narration, no banners, no commented-out code, no "IMPORTANT do not remove" sermons: encode the constraint as a test or a type, then delete the comment.

## Principles

Read the leaf in full before citing. Name each principle that changed a decision in the trail, with the specific choice it changed.

**Core**
- **Laziness Protocol** (`principle-laziness-protocol`). Sizing a diff, tempted to add a layer. Smallest change; bias to deletion; ≤3 layers to an answer.
- **Foundational Thinking** (`principle-foundational-thinking`). Before logic: data shapes, scaffold-vs-feature order, what concurrent actors share.
- **Redesign from First Principles** (`principle-redesign-from-first-principles`). New requirement into old design: as if it were day-one, not bolted on.
- **Attack the Premise** (`principle-attack-the-premise`). Two fixes sharing a premise both failed: census the actors, question the premise.
- **Subtract Before You Add** (`principle-subtract-before-you-add`). Dead code and stub refs out first, then build.
- **Minimize Reader Load** (`principle-minimize-reader-load`). Count layers and hidden state; collapse one-caller wrappers.
- **Outcome-Oriented Execution** (`principle-outcome-oriented-execution`). Migrations with phases in the brief: converge on the end state, no throwaway compat code.
- **Experience First** (`principle-experience-first`). Fewer polished things over more rough ones. The user includes the next maintainer.
- **Exhaust the Design Space** (`principle-exhaust-the-design-space`). Row 1 novel UI only: 2–3 throwaway variants behind one switcher, screenshot each, pick.
- **Build the Lever** (`principle-build-the-lever`). Anything touched 3+ times or any check a reviewer should rerun: a script, not hands.

**Architecture**
- **Model the Domain** (`principle-model-the-domain`). Branchy or stateful code: enum + `match`, registry, state machine, value object.
- **Boundary Discipline** (`principle-boundary-discipline`). Guards at Form Requests, MCP tool input, API clients; pure logic inside.
- **Type System Discipline** (`type-system-php`, the PHP rewrite of `principle-type-system-discipline`). Illegal states unrepresentable: value objects for IDs, enums, DTOs at boundaries, no `mixed` to silence Larastan.
- **Make Operations Idempotent** (`principle-make-operations-idempotent`). Jobs, schedulers, external writes: same end state on rerun.
- **Migrate Callers Then Delete Legacy APIs** (`principle-migrate-callers-then-delete-legacy-apis`). One wave, no shims.
- **Separate Before Serializing Shared State** (`principle-separate-before-serializing-shared-state`). "We need a lock" is a smell; split the target first.

**Verification**
- **Prove It Works** (`principle-prove-it-works`). Real artifact, not "it compiles." Row 6: live endpoint during build.
- **Fix Root Causes** (`principle-fix-root-causes`). Reproduce, ask why, no silencing null checks, grep for siblings.
- **Sequence Verifiable Units** (`principle-sequence-verifiable-units`). Each unit ends in a check; failing test lands before the fix.
- **Test Behavior, Not Implementation** (`test-behavior-pest`, the Pest rewrite of `principle-test-behavior-not-implementation`). Would it pass if every method returned null? Then rewrite or delete it. No tests that police process.

**Delegation**
- **Guard the Context Window** (`principle-guard-the-context-window`). Bulk to subagents; summaries in the main thread. Here that's structural: the Delegation section makes every implementation a subagent's.
- **Never Block on the Human** (`principle-never-block-on-the-human`; the Gate section above is its rewrite for this loop). Reversible in-branch work proceeds. Every row stops at the push. Vault moves and irreversible outside writes always ask.

**Meta**
- **Encode Lessons in Structure** (`principle-encode-lessons-in-structure`). Same instruction twice: a hook, a script, a lint, not more prose. Observability without ceremony.
