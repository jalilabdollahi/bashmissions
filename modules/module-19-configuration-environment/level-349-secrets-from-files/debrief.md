# Debrief: Secrets from Files

The mental model: **where a secret lives decides who can see it.** Environment
variables are inherited by every child process, show up in `/proc`, in crash
reports and in `docker inspect`, and tend to be printed by well-meaning debug
code. A file with mode 0400, mounted only into the container that needs it, is much
harder to leak. The `*_FILE` convention (used by Docker secrets, Kubernetes and
many official images) lets the same program accept either, so the platform decides
and the application does not care.

The script shows three habits. Resolve by rule, in a fixed order, and treat
ambiguity as an error rather than a guess: if both `DB_PASSWORD` and
`DB_PASSWORD_FILE` are set, one of them is probably stale, and using the wrong
one would be a silent failure. Report what you learned without revealing it: a
length and a source are enough for a log line. And process everything before
failing, so the person fixing the deployment sees all the problems.

Under the hood, `${!name}` is indirect expansion: Bash first expands `name`, then
uses the result as a variable name. It is the safe replacement for `eval`.
`$(<file)` is a special case Bash handles itself, and like every command
substitution it strips trailing newlines.

Going further: all the configuration so far was flat `key=value`. Many real files
group settings in `[sections]`. The next level parses INI files.
