<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Correctness section) · changes: reframed around the brief and the feature file -->

# Lens: goal-alignment

Does the change do what the brief and the feature file say, no more and no less?

- **Every acceptance line is met**, and met the way it's written, not by a nearby easier thing.
- **Nothing missing.** A briefed item silently dropped, or deferred without saying so, is a finding.
- **Nothing extra.** Scope the brief didn't ask for (new features, new process, new docs) is a finding unless the brief's Decisions section justifies it.
- **Correct for the intent.** The edge cases the intent implies (empty, many, first run, second run, the owner vs an agent) behave sensibly. Trace the happy path and one sad path end to end.
- **Docs still true.** `CLAUDE.md`, `docs/roadmap.md` and the feature file describe what now exists. A statement the change made false is a finding.
