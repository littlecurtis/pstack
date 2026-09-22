<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Verification section) · changes: condensed to one lens -->

# Lens: tests

Would these tests fail if the change were broken?

- **Every acceptance line has a test**, and that test exercises that line, not a neighbouring one. If the repo keeps feature specs with ids, the test cites the id.
- **Behavior, not implementation** (**principle-test-behavior-not-implementation**, or **test-behavior-pest** in a PHP repo). Apply the litmus to each new test: would it pass if every function it calls returned null? Flag weak assertions, mock-only assertions, constant pins, and fixture-asserts-fixture.
- **The real path.** Endpoints and tools are tested the way callers reach them (over HTTP, with a real credential where auth matters), UI through the framework's component or browser harness, and outside APIs through fakes whose response shapes match the live API (not invented ones). Stray real network calls are blocked wherever an outside API is involved.
- **Failure modes.** Each refusal path the feature promises (unconfigured, outside API error, stale data, unauthorized caller) has a test.
- **Run them.** The repo's test command on the touched files, with the counts reported. A test you didn't run is not evidence.
