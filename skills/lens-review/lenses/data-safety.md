# Lens: data-safety

Could this change lose, corrupt or strand data?

- **Migrations.** A new migration, never an edit to one that has already run anywhere. The down path reverses the up path, and both have been run. Column types match what will actually be stored (an id column sized for one id format can't hold another).
- **Every engine the repo runs on.** If dev, test and production use different databases, nothing relies on what only one of them does (JSON paths, `ALTER` limits, defaults, foreign-key behavior).
- **Destructive steps.** Dropped columns and tables are named in a keep/remove table in the brief. Nothing destructive runs against production or a shared database without Curtis.
- **Append-only data.** Anything the repo treats as a log, journal or audit trail is only appended to. Nothing new updates or deletes it.
- **Transactions.** A multi-step write is all-or-nothing. For an outside call inside a DB transaction: what if the outside write succeeds and the commit fails, or the reverse?
- **Production path.** How does this schema reach the data already in production (what the deploy runs), and is that safe on the rows that are there now?
