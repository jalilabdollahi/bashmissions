# Common Mistakes for Export a Variable

- Setting a variable without `export` and wondering why a child script can't see it. Only exported variables become part of the child's environment.

- Quoting `bash -c "..."` with double quotes: the parent shell expands `$GREETING` *first*, baking the value into the command, before the child even starts. Use single quotes to defer expansion.

- Calling `export` after the assignment in a way that's pointless: `export NAME=value; NAME=other` — the second assignment leaves `NAME` exported, but if you check the child it still sees `other`. That's actually fine; the bug shape is when people unset and re-set without re-exporting.

- Believing `export` propagates *up* the process tree. It doesn't. Children inherit; the parent of your script never sees its exports.

- Exporting unintentionally and leaking secrets. If you `export AWS_SECRET_ACCESS_KEY=...` in an interactive shell, every command you run inherits it.
