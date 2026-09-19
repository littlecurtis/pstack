# Lens: reversibility

If this turns out wrong, how do we undo it, and what can't be undone?

- **Code rollback.** Does `git revert` of the commit restore the old behavior cleanly, including config and routes? Say so, or name what doesn't revert.
- **Outside effects.** Anything written to another system (Hevy, Gmail, a sent message) survives a revert. Is each such write deliberate, approved, and journaled with enough detail to find and undo it by hand?
- **Idempotency** (**principle-make-operations-idempotent**). What happens if this runs twice, or a previous run crashed halfway: a retried verdict, a rerun sync, a replayed webhook? Duplicates in an outside system are a finding.
- **Config.** For a new env var: what happens on a deploy where it's missing? For a changed default: what does it do to existing installs?
- **Failure recovery.** When the outside call fails midway, what state is left, and is there a way back that doesn't need a database edit?
