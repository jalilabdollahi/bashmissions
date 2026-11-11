# Walkthrough: Command Groups

## The plan

Two jobs for the same tool. First, a report page made of three different
commands that must land in one file. Second, an error exit that has to print a
message *and* leave the script. Both are "several commands acting as one", which is
what `{ ...; }` is for.

## Step by step

The usual argument check comes first. Then the early exit:

```bash
[[ -r $list ]] || { echo "cannot read $list" >&2; exit 1; }
```

Read it as "either the file is readable, or do these two things". The group
makes `echo` and `exit` one unit that belongs to the `||`. A subshell
`( ...; exit 1 )` would not work here: it would exit only itself and the
script would carry on to create an empty report.

Next, the count. `awk 'NF'` keeps the non-blank lines, `sort -u` sorts and
removes duplicates, `wc -l` counts. macOS pads that number with spaces, so wrap
it in `$(( ))`.

Now the report. Without a group you would redirect each command and open the
file three times:

```bash
{
  echo "== fleet report =="
  awk 'NF' "$list" | sort -u
  echo "total: $count"
} > report.txt
```

The file is opened once, before the first command runs, and everything the
group writes to standard output goes into it. That also guarantees all-or-
nothing behaviour for the file as a unit: no accidental `>>` leftovers from
a previous run.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LIST" >&2
  exit 2
fi
list=$1

[[ -r $list ]] || { echo "cannot read $list" >&2; exit 1; }

count=$(( $(awk 'NF' "$list" | sort -u | wc -l) ))

{
  echo "== fleet report =="
  awk 'NF' "$list" | sort -u
  echo "total: $count"
} > report.txt

echo "wrote report.txt ($count servers)"
```

## Try it by hand

```bash
printf 'marlin\nanchovy\n\nmarlin\n' > fleet.txt
./solution.sh fleet.txt && cat report.txt
./solution.sh nothing.txt; echo "exit $?"
```

## An alternative

Three `>>` redirections would also build the file, but you must remember to
truncate it first, and each line opens and closes the file again. One group,
one redirect, is shorter and harder to get wrong.
