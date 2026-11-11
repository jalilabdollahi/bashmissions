# Walkthrough: Audit Wrapper

## The plan

`audited` sits between the caller and the command. It runs the command with its
arguments untouched, then writes a record of what ran and how it ended, and
finally gives the same exit status back. Callers see no difference except that
a log appears.

## Step by step

The log location is configurable with a sensible default. `${AUDIT_LOG:-audit.log}`
uses the default when the variable is unset *or empty*:

```bash
log=${AUDIT_LOG:-audit.log}
```

Run the command so that a failure is recorded rather than fatal:

```bash
audited() {
  local rc=0 words
  "$@" || rc=$?
```

To log the words faithfully, `printf '%q '` writes each argument in a form that
Bash could read back: `a;b` becomes `a\;b`, a space becomes `\ `. `-v words`
puts the result in a variable. Every item is followed by a space, so trim the
last one with `${words% }`:

```bash
  printf -v words '%q ' "$@"
  printf '%s: %s status=%d\n' "${USER:-unknown}" "${words% }" "$rc" >> "$log"
  return "$rc"
}
```

`>>` appends, and creates the file only when something is written, so an
empty run leaves no log.

The loop uses `read -ra words`: it splits the line into an array without
expanding globs (a `*` stays a `*`; that is why the log shows `\*`). A blank line
gives an empty array and is skipped. The caller keeps going whatever happens:

```bash
failed=0
while read -ra words; do
  (( ${#words[@]} > 0 )) || continue
  audited "${words[@]}" || failed=1
done
exit "$failed"
```

## The not-found case

A command that does not exist makes Bash print "command not found" itself and
return 127. The wrapper needs nothing special: it logs `status=127` like any
other result.

## Try it by hand

```
printf 'echo hello\nfalse\nnosuch thing\n' | ./solution.sh; cat audit.log
```

## Alternative

Log *before* running as well, so that a command that hangs or kills the
machine still leaves a trace. The usual compromise is two lines (start and
result) with a shared id; this level keeps one line per command for simplicity.
