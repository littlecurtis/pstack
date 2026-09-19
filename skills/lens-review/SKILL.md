---
name: lens-review
description: "The review step of curtis-mode: one readonly Claude subagent per lens in the change's routing-table row, each with its own rubric, then a lead judgment into numbered Act on / Consider / Noted / Dismissed findings. Use for /lens-review, 'review this', or after self-critique on any row."
disable-model-invocation: true
---
<!-- derived-from: skills/interrogate/SKILL.md @ 157aae3 · changes: one reviewer per LENS (from the routing-table row) instead of one per model, each with its own rubric in lenses/; findings numbered for one-gesture replies; output goes to the vault brief's Review section -->

# Lens review

Spawn one reviewer per lens in the union set of the rows touched. Each reviewer gets the same intent and diff and a different rubric. The signal comes from each reviewer looking at the change through one narrow question, not from assigned personas.

The deliverable is a synthesized, numbered verdict. Do NOT auto-apply changes.

## Step 1, Scope

- The diff: `git diff <base>..HEAD` for committed work, `git diff` plus `git diff --cached` for uncommitted.
- The rows touched and their union lens set, from the brief (curtis-mode's routing table).
- Any context files a reviewer needs to judge the change: the feature file (in mesh-mind, `docs/features/`), the files the diff calls into.

## Step 2, State the intent

One paragraph: what the change is for, who uses it, what it must not break. Derive it from the brief, the feature file and the commits. If the intent is unclear, that is itself an Act-on finding; don't invent one.

## Step 3, Spawn the reviewers

One `Agent` call per lens, **all in a single message** so they run in parallel:

- `subagent_type`: `curtis-agent` (`pstack:curtis-agent` when installed as a plugin; falls back to `general-purpose` if the agent isn't registered)
- `model`: `opus`
- The prompt: `references/reviewer-prompt.md` filled with the intent, the diff (or file paths to read, for a large diff), and the full text of `lenses/<lens>.md`. A lens with no rubric here (`house-conventions`, `brand-voice`) is repo-specific: the repo's `CLAUDE.md` says where its rubric lives. No rubric anywhere is an Act-on finding, not a skipped lens.
- Tell each reviewer it is readonly: it reads and runs read-only commands (tests, `git`, `grep`), and edits nothing.

The lens set comes from the rows. Don't add lenses no row names; add one only when the brief says why.

## Step 4, Synthesize

1. **Parse** every reviewer's findings.
2. **Consensus.** A finding two or more lenses raise independently is highest signal.
3. **Lone findings.** Still read them; weight by how concrete the evidence is.
4. **Deduplicate.** Merge the same issue described two ways, noting every lens that raised it.
5. **Disagreements.** One lens flags what another explicitly clears: say so.

## Step 5, Lead judgment

You are the lead reviewer, not an aggregator. Read `references/lead-judgment.md`. On rows 5 and 6, do this step as a Fable subagent (or on Fable yourself) given the synthesized findings.

Bucket every finding:

- **Act on.** Real issues for correctness, security or maintainability given the actual goal. Fix before hand-back unless it needs a product call.
- **Consider.** Legitimate, but the cost of addressing it now may not be worth it. Curtis decides.
- **Noted.** Valid but not actionable at this stage.
- **Dismissed.** Wrong, nitpicky, or missing context. One line why.

## Output

Write this into the brief's **Review** section and into the reply:

```
### Intent
> <the intent paragraph>

### Reviewers
- security (opus): 2 findings
- tests (opus): 0 findings

| # | lens | finding | bucket | why |
|---|---|---|---|---|
| 1 | security | … file:line … | Act on | … |
| 2 | tests, style | … | Consider | … |

### Agreement map
<where lenses agreed, where they diverged, what that says>
```

Number findings across the whole table so Curtis can reply `2: fix`, `all: go`. After fixing Act-on items, add a line under the table naming each fix's commit.

## Independence

These reviewers run inside the same Code session that built the change. That makes them separate contexts with narrow rubrics, not an independent human-grade review. Say "lens review (in-session subagents)" in the hand-back, never "independent review".
