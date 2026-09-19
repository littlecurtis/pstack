<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Security section) · changes: condensed to one lens, grounded in mesh-mind -->

# Lens: security

Could this change let the wrong caller read or change something, or leak something?

- **Auth boundaries.** Every new route sits behind `auth` (web) or `auth:api` (MCP). For every new MCP tool: is it meant for every credential, or should it extend `OwnerOnlyTool`? Can an agent-scope token reach an owner-only action by any path (a propose action that applies itself, a tool calling a service directly)?
- **The write path.** Anything an agent wants to change goes through `propose` and waits for `verdict`. Flag any tool or job that writes business data, or calls an outside system's write API, directly.
- **Input.** Trace MCP arguments, Livewire input and webhook bodies to where they're used. Are they validated at the boundary (`$request->validate()`, `Validator::make()`)? Is there any path from input to raw SQL, a shell, `eval`, `{!! !!}` or an outside API without a check?
- **Secrets.** Keys and tokens come only through `config()`, never through code, the journal (`events.after`), exception messages or logs. OAuth tokens are stored encrypted.
- **Webhooks and callbacks.** The signature or token is verified before any work; the OAuth `state` is checked.
- Only flag what you can trace through the code. "This could be injectable" without the input path is not a finding.
