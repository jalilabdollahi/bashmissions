# Walkthrough: Safe Temp Files

## The plan
Keep the same logic (store, sort, take three) but change how the scratch file is
born and how it dies.

## The attack in one picture
`/tmp`-style folders are shared. If your script always writes
`$TMPDIR/report.tmp`, anybody who can write there can create that name first as a
symlink to something valuable. `cat > "$work"` follows the symlink and replaces
the victim file with your invoice list. Even adding `$$` (the PID) only shrinks
the search: process ids are small and guessable.

## Steps
1. Ask the system for a name: `work=$(mktemp "$TMPDIR/invoices.XXXXXX")`.
   mktemp refuses to reuse an existing path, creates the file with mode 600 and
   prints where it put it.
2. Register cleanup right away:
   `trap 'rm -f "$work"' EXIT`. The single quotes delay expansion until exit,
   when `$work` is set.
3. Read stdin into the file and print the top three:
   `sort -rn "$work" | head -n 3`. `-n` compares numbers, `-r` reverses.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
work=$(mktemp "$TMPDIR/invoices.XXXXXX")
trap 'rm -f "$work"' EXIT
cat > "$work"
sort -rn "$work" | head -n 3
```

## Try it
```
export TMPDIR=$PWD; printf '5\n90\n12\n7\n' | ./solution.sh; ls
```
The folder should contain no `invoices.*` leftovers.

## Alternative
You could skip the file: `sort -rn | head -n 3` reads stdin directly through a
pipe and needs no scratch file at all. That is the best answer for this job, and
the level uses a file only because many real tasks (diffing, multi-pass edits)
genuinely need one.
