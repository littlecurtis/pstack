---
name: type-system-php
description: "Apply when designing types, reviewing a signature, or writing PHP in this repo. Make illegal states unrepresentable with enums and readonly value objects, parse external data at the boundary, don't silence the analyzer, make matches exhaustive, derive shapes from the authoritative schema."
disable-model-invocation: true
---
<!-- derived-from: skills/principle-type-system-discipline/SKILL.md @ 157aae3 · changes: rewritten for PHP 8.5 + Laravel; the rules are unchanged -->

# Type System Discipline

PHP's type system is weaker than TypeScript's, and that is a reason to use all of it, not to skip it. A case the types let you ignore becomes a runtime failure. Prefer defining errors and special cases out of existence over adding handlers for them.

**The patterns:**

- **Make illegal states unrepresentable.** A closed set of states is a backed enum, not a string column read with `===`: `ProposalStatus::Pending`, cast on the model (`'status' => ProposalStatus::class`). Don't model state as a bag of nullable fields where contradictory combinations are storable. `completed` plus `completed_at` admits "completed with no time"; derive the boolean from the one source. `commitments` has only `completed_at`: `Client::openCommitments()` filters on it being null, and `Commitment::isOverdue()` derives from it and `due_on`.
- **Types are constructions, not restrictions.** Build the shape from the values you want. A routine's sets are a list of set arrays validated once (`HevyRoutine::rules()`), not an array you re-check wherever it's used.
- **Give semantic primitives their own type** when mixing them up would be a bug. Two string ids that mean different things (a ULID `subject_id`, a Hevy UUID) never share a slot; the Hevy id rides in JSON because the column's type says ULID. Where a value travels between services, a `final readonly class` with a named constructor that validates once beats a raw string passed around.
- **External data is untyped until parsed.** MCP tool arguments, Livewire input, HTTP responses from Hevy or Google, `.env` values, JSON columns. Validate at the boundary (`$request->validate()`, `Validator::make()`, `config()` with a typed default), then trust the result inside. See **principle-boundary-discipline**.
- **Don't lie to the analyzer.** No `mixed` to make a signature pass, no `@phpstan-ignore` or `/** @var */` cast to paper over a shape you haven't proven, no `(array)` coercion hiding a null you didn't expect. If you can't prove it, validate it or accept the cast as a hazard and say so.
- **Exhaustive matching.** `match` on an enum throws `UnhandledMatchError` for a case nobody handled, so prefer `match` over `if` chains and `switch`. Keep a `default` arm only where "anything else" is a real answer (an unknown proposal action is refused by name), never to swallow a case you forgot.
- **Derive shapes from the authoritative schema.** The migration owns a table's shape and the model's `casts()` mirror it. An external API's documented schema (Hevy's OpenAPI) owns the request shape, so read it before hand-rolling one.
- **Strengthen a type only where partiality appears.** A null check, a "should never happen" throw or a `?? ''` marks the place a type is too weak. Push the check up to where the value enters. Then stop: the goal is to make every use site handle its real cases, not to describe the data as precisely as possible.

**The tests:**

- "Can I write a comment explaining when this combination of fields is valid?" If yes, the model is too loose. Split it, or derive one field from the other.
- "Do two parameters share a type but mean different things?" Give one of them its own type, or at least its own name at every call site.
- "Where did this `mixed`, this `(array)`, this `?? null` come from?" Trace it to the boundary and validate there instead.
- "If a new enum case is added next month, will a `match` throw or will an `if` fall through silently?" Make it throw.
- "Is this array shape duplicating one a migration, a config file or an API schema already owns?" Derive from that instead.
