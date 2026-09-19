<!-- derived-from: skills/interrogate/references/code-quality-review.md @ 157aae3 (also agents/comment-sicko.md) · changes: condensed to one lens, comment rules folded in, persona dropped -->

# Lens: style

Does the change fit the codebase and leave it simpler, or messier?

- **Structural simplification first.** Is there a move that deletes a branch, a helper or a layer while keeping the behavior? Push for that over local tidying.
- **Spaghetti.** New ad-hoc conditionals in unrelated flows; a second boolean that must stay in sync with a first; an `if` chain growing by one more case where an enum + `match` belongs (**principle-model-the-domain**).
- **Reader load.** One-caller wrappers, pass-through layers, state the reader has to hold (**principle-minimize-reader-load**). A file pushed past ~1,000 lines needs a reason.
- **House conventions.** Sibling files' structure and naming; Laravel built-ins before custom code; `config()`, not `env()`; drawers, not modals; one title and one muted sentence per page.
- **Comments.** No narration of what the next line does, no banners, no commented-out code, no "IMPORTANT do not remove" sermons: encode the constraint as a test or a type, then delete the comment. A comment that describes retired machinery is a finding. The only comments that stay: license headers; behavior forced by something we can't reshape (a vendor API, Laravel, PHP, the platform); a docblock that defines a public contract (a tool's `#[Description]`, a service method's shape); a pointer to the feature file or gotcha that explains a constraint the code can't express. A surprise in our own code is not a keep reason: flag the symbol for a rename or reshape instead.
- Pint is not this lens: formatting is already enforced, so don't report what pint fixes.
