# Walkthrough: Collect Job Results

## The plan

Ollie's loop failed because of a basic rule: a background job is a copy of the
shell, and a copy cannot change the original's variables. What *is* shared
between processes is the file system. So: one file per job, filled by the job,
read by the parent once everybody is done.

## Step by step

Make a private place for the results. `mktemp -d` creates a new empty folder
with an unguessable name (inside `$TMPDIR`) and prints it:

```bash
tmp=$(mktemp -d)
```

Number the hosts and start one job each, redirecting standard output *and*
standard error into that job's own file. Using the position as the file name
means the file name carries the order:

```bash
n=0
for host in "$@"; do
  n=$((n + 1))
  latency "$host" > "$tmp/$n" 2>&1 &
done
wait
```

The redirection belongs to the job. The `&` goes at the very end of the line.
After `wait`, every file is complete. Read them in numeric order and the
report follows the argument order, not the finishing order:

```bash
for ((i = 1; i <= n; i++)); do
  cat "$tmp/$i"
done
```

Last, clean up and print the count:

```bash
rm -rf "$tmp"
echo "checked $# hosts"
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh HOST..." >&2
  exit 2
fi

tmp=$(mktemp -d)

n=0
for host in "$@"; do
  n=$((n + 1))
  latency "$host" > "$tmp/$n" 2>&1 &
done
wait

for ((i = 1; i <= n; i++)); do
  cat "$tmp/$i"
done

rm -rf "$tmp"
echo "checked $# hosts"
```

## Try it by hand

```bash
./solution.sh anchovy dory-down eel
```

Look inside the scratch folder while the jobs run: open a second terminal and
`ls "$TMPDIR"`, or add `sleep 5` before the `rm`.

## An alternative

Bash can read from several files at once, but a plain `cat "$tmp"/*` sorts
names as text: `10` comes before `2`. The numeric loop above avoids that
trap when there are ten or more hosts.
