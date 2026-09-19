<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Verification section) · changes: condensed to one lens, grounded in mesh-mind's harnesses -->

# Lens: tests

Would these tests fail if the change were broken?

- **Every acceptance line has a test citing its id** (`docs/features/<slug>.md`), and that test exercises that line, not a neighbouring one.
- **Behavior, not implementation** (**test-behavior-pest**). Apply the litmus to each new test: would it pass if every method it calls returned null? Flag weak assertions, mock-only assertions, constant pins, and fixture-asserts-fixture.
- **The real path.** MCP tools are tested over HTTP with a real token (the `rpc()` harness), Livewire through `Livewire::test()`, and outside APIs through `Http::fake()` with response shapes that match the live API (not invented ones). `Http::preventStrayRequests()` wherever an outside API is involved.
- **Failure modes.** Each refusal path the feature promises (unconfigured, outside API error, stale data, unauthorized caller) has a test.
- **Run them.** `php artisan test --compact` on the touched files, with the counts reported. A test you didn't run is not evidence.
