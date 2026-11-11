# Debrief: Quoted Here-Docs

## What you learned

Quoting decides when substitution happens. In `<<EOF` it happens now, while
your script runs. In `<<'EOF'` it never happens: the text is passed on exactly
as written, to be interpreted by whoever reads it later.

## Under the hood

The shell inspects the delimiter word. If any part of it is quoted (`'EOF'`,
`"EOF"` or `\EOF`), it skips parameter expansion, command substitution and
arithmetic in the body, and does not treat backslash specially. If it is bare,
it applies those expansions as in double quotes. The command receiving the
text sees no difference, only the content changes.

## In real work

Generating scripts, systemd units, Dockerfiles, nginx or cron files, SQL with
`$$` in it, or help text containing example commands. Whenever the output is
code or config for someone else's shell, quote the delimiter.

## Going further

Both here-doc forms feed a whole block. For a single short string there is a
lighter form, the here-string, coming next.
