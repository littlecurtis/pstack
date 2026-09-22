<!-- derived-from: skills/interrogate/references/rubric.md @ 157aae3 (Security section) · changes: condensed to one lens -->

# Lens: security

Could this change let the wrong caller read or change something, or leak something?

- **Auth boundaries.** Every new route, endpoint or tool sits behind the right authentication. For each one: which callers is it meant for, and can a lower-privilege caller (a guest, an agent token, another tenant) reach a higher-privilege action by any path?
- **The write path.** If the repo routes writes through an approval step or a single service layer, flag any new path that writes business data, or calls an outside system's write API, around it.
- **Input.** Trace request bodies, form input, tool arguments and webhook payloads to where they're used. Are they validated at the boundary? Is there any path from input to raw SQL, a shell, `eval`, unescaped HTML output or an outside API without a check?
- **Secrets.** Keys and tokens come only through config, never through code, stored records, exception messages or logs. OAuth tokens are stored encrypted.
- **Webhooks and callbacks.** The signature or token is verified before any work; the OAuth `state` is checked.
- Only flag what you can trace through the code. "This could be injectable" without the input path is not a finding.
