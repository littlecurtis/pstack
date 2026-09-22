# Lens: reversibility

If this turns out wrong, how do we undo it, and what can't be undone?

- **Code rollback.** Does reverting the change restore the old behavior cleanly, including config and routes? Say so, or name what doesn't revert.
- **Outside effects.** Anything written to another system (a third-party API, a sent email or message, a payment) survives a revert. Is each such write deliberate, approved, and logged with enough detail to find and undo it by hand?
- **Idempotency** (**principle-make-operations-idempotent**). What happens if this runs twice, or a previous run crashed halfway: a retried job, a rerun sync, a replayed webhook? Duplicates in an outside system are a finding.
- **Config.** For a new env var: what happens on a deploy where it's missing? For a changed default: what does it do to existing installs?
- **Failure recovery.** When the outside call fails midway, what state is left, and is there a way back that doesn't need a manual database edit?
