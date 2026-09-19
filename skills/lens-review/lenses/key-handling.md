# Lens: key-handling

Could a credential leak, or go missing in production?

- **Source.** Keys and client secrets are read only through `config('mesh.*')` or `config('services.*')`, backed by `.env` locally and Forge → Environment on milano. Never `env()` outside `config/` (gotcha G7: under `config:cache` it returns the default).
- **Not in git.** `git log -p` for the change contains no key, token or secret, and no real account id that isn't needed. Test fixtures use synthetic values.
- **Not in the journal or errors.** The key rides a header, never the URL or query string. `events.after`, exception messages and logs are redacted, and a test asserts the key never appears in the events table.
- **Stored tokens.** OAuth access and refresh tokens are encrypted at rest (`encrypted` cast) and never returned by an MCP tool.
- **Missing key.** With the key unset, the feature refuses by name (`<thing>_not_configured`) instead of throwing a 500, and the refusal names the env var. `.env.example` documents it.
- **Production.** The hand-back tells Curtis which env vars must be in Forge before the deploy that needs them.
