# Lens: tests-still-pass

For a refactor: did the behavior stay exactly the same?

- **Same suite, same result.** The full suite was run before and after, and both counts are in the hand-back. A test changed in a refactor is a finding unless the change only follows a rename.
- **Characterization first.** Behavior the refactor touches that no test covered was pinned by a test *before* the move, and that test passes on both sides.
- **No quiet behavior change.** Different defaults, ordering, error messages, logged events or response shapes are all behavior. Diff them.
- **Reader load dropped.** The point of a refactor is a simpler path for the reader. If it didn't get simpler, say so: that's a signal to revert.
