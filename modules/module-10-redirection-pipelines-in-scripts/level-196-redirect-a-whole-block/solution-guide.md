# Walkthrough: Redirect a Whole Block

## The plan

Collect the header, the per-host lines and the footer into one group, then
point the group's stdout at the report and its stderr at the warnings file.

## Step by step

The starter already checks the arguments and removes the day from `$@` with
`shift`, so `"$@"` is now just the hosts.

Per-command redirection would look like this (do not write it):

```bash
echo "header" > report.txt
disk-usage "$h" >> report.txt 2>> warnings.txt
```

It is easy to forget a `>>` or to type `>` by mistake, and the files are opened
again for every command. Wrapping the commands in braces solves both:

```bash
{
  echo "== Capacity report for $day =="
  for host in "$@"; do
    disk-usage "$host"
  done
  echo "== end =="
}
```

A brace group is a command list that behaves like a single command, so a
redirection after `}` applies to all of it. We need two:

```bash
} > "report-$day.txt" 2> "report-$day.err"
```

Both files are created (and truncated) at the start. That is why the .err file
exists empty when no warnings occur, and why old reports are replaced.

Two syntax rules: a space after `{`, and the last command inside must end
with a newline or `;` before `}`.

## The complete solution

See answer.sh.

## Trying it by hand

```bash
./solution.sh 2026-11-12 grouper-full eel
cat report-2026-11-12.txt report-2026-11-12.err
```

## An alternative

A subshell `( ... ) > file` also groups commands, but it runs in a child
process, so variables set inside vanish. Braces run in the current shell and
are the better default.
