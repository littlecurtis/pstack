# Lens: key-handling

Could a credential leak, or go missing in production?

- **Source.** Keys and client secrets come from the repo's one config path (environment variables read through its config layer), never hard-coded. If the framework caches config, nothing reads the environment directly outside that layer.
- **Not in git.** `git diff` for the change contains no key, token or secret, and no real account id that isn't needed. Test fixtures use synthetic values.
- **Not in logs or errors.** The key rides a header, never the URL or query string. Stored records, exception messages and logs are redacted, and a test asserts the key never appears where records are persisted.
- **Stored tokens.** OAuth access and refresh tokens are encrypted at rest and never returned to a caller that doesn't need them.
- **Missing key.** With the key unset, the feature refuses by name (`<thing>_not_configured`) instead of crashing, and the refusal names the env var. The example env file documents it.
- **Production.** The hand-back tells Curtis which env vars must be set in production before the deploy that needs them.
