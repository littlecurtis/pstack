---
name: test-behavior-pest
description: "Apply when you write, change, or keep a test. Call the code the way its users do and assert the result they observe against a literal expected value. If the test would still pass when every method it calls returned null, rewrite the assertion or delete the test."
disable-model-invocation: true
---
<!-- derived-from: skills/principle-test-behavior-not-implementation/SKILL.md @ 157aae3 · changes: rewritten for Pest/PHPUnit and Laravel; the five shapes and the litmus are unchanged -->

# Test Behavior, Not Implementation

A test calls the code the way its users do and asserts the result they observe against a literal expected value. In this repo the users are an MCP caller, the owner in a Livewire screen, and the next service up. A test that asserts which calls the code made, or restates a constant the code contains, does neither.

The litmus: before you keep a test, ask whether it would still pass if every method it calls returned `null`. If yes, it observes no behavior and cannot fail for a defect. Rewrite the assertion or delete the test.

**Why:** A test that cannot fail for a defect costs CI time and review attention and catches nothing. A constant pin also fails when someone legitimately edits the constant, so it blocks the edit it should allow. The retired node-model suite (78 of 91 test files) was full of tests that policed the process instead of the product.

**Five shapes that still pass when every method returns `null`:**

- **Weak or no assertion.** No assertion, or only `assertNotNull`, `assertTrue($x !== null)`, `assertInstanceOf`, `assertOk()` on a page that renders even when broken, `expectNotToPerformAssertions`.
- **Mock or absence only.** Only `shouldHaveReceived`, `Http::assertSent(fn () => true)`, `Queue::assertNothingPushed`, `assertDatabaseCount('x', 0)`, `assertEmpty`, `assertNotSame($wrong)`.
- **Self-referential.** The expected value comes from the code under test: `assertSame($presenter->lines($r), $presenter->lines($r))`, or an expected array built by calling the same helper the subject calls.
- **Constant pin.** The assertion restates a hand-maintained constant, config default, enum value list or copy string: `assertSame(25, ReviewQueue::PER_PAGE)`, `assertSame('owner:curtis', config('mesh.owner_actor'))`.
- **Fixture asserts fixture.** The assertion reads a model the test just created and the subject never runs: `Client::factory()->create(['name' => 'X']); assertDatabaseHas('clients', ['name' => 'X'])`.

**The fix:** run the subject inside the test with one concrete input and assert the literal output or the observable effect. Call the MCP tool over HTTP and assert the returned field (`assertSame('pending', $created['status'])`); render the Livewire component and assert what the owner sees (`->assertSee('Create Hevy routine "Hybrid Upper 1"')`); for an HTTP fake, assert the payload it received (`$r['routine']['title'] === 'Hybrid Upper 1'`), not that a request happened. For an absence, assert the presence on the other input in the same test. For a constant, test the mechanism that reads it with one input. When no such assertion exists, delete the test.

**Keep** a test that checks a relation across the system rather than a value: every table has its MCP tool (`McpParityTest`), the owner-only set is exactly the tools that should be (`McpServerWayInTest`), a banned word stays out of the code (`VocabularyTest`). Each of these fails when someone adds the thing it guards against.
