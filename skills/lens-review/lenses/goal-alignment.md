<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Correctness section) · changes: reframed around the brief and the feature spec -->

# Lens: goal-alignment

Does the change do what the brief (and the feature spec, if the repo keeps one) says, no more and no less?

- **Every acceptance line is met**, and met the way it's written, not by a nearby easier thing.
- **Nothing missing.** A briefed item silently dropped, or deferred without saying so, is a finding.
- **Nothing extra.** Scope the brief didn't ask for (new features, new process, new docs) is a finding unless the brief's Decisions section justifies it.
- **Correct for the intent.** The edge cases the intent implies (empty, many, first run, second run, each kind of caller) behave sensibly. Trace the happy path and one sad path end to end.
- **Docs still true.** `CLAUDE.md`, the README, and any roadmap or feature doc describe what now exists. A statement the change made false is a finding.
