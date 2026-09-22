# Lens: tests-actually-run

For test-only changes: do the new tests prove anything?

- **They ran.** The new tests were executed and their output is in the hand-back, not "should pass".
- **They can fail.** For at least one new test, break the code it covers (flip a condition, return early), confirm it goes red, then restore. Report which mutation you made.
- **Behavior, not implementation** (**principle-test-behavior-not-implementation**, or **test-behavior-pest** in a PHP repo). No test in the change passes when every function it calls returns null.
- **No process-policing.** A test that asserts the shape of a doc, a count of files, or that a process step happened is a finding, unless it guards a real invariant.
- **Deterministic.** No sleeps, no reliance on wall-clock ordering or second-precision timestamps, no network without a fake.
