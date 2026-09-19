# Lens: data-safety

Could this change lose, corrupt or strand data?

- **Migrations.** A new file, never an edit to an applied one. `down()` reverses `up()`, and both `migrate:fresh` and `migrate:refresh` have been run. Column types match what will be stored (a ULID column cannot hold an outside UUID).
- **SQLite and MariaDB alike.** Nothing only one engine does (JSON path quirks, `ALTER` limits, default values, foreign-key behavior). Cross-field rules live in app code.
- **Destructive steps.** Dropped columns and tables are named in a keep/remove table in the brief. Nothing destructive runs against milano without Curtis.
- **The journal.** `events` is only appended to, and proposals are never deleted. Nothing new updates or deletes either.
- **Transactions.** A multi-step write is all-or-nothing. For an outside call inside a DB transaction: what if the outside write succeeds and the commit fails, or the reverse?
- **Production path.** How does this schema reach milano's existing data (a plain `migrate --force` in the deploy), and is that safe on the rows that are there now?
