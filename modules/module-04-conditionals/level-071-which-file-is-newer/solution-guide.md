# Walkthrough: Which File Is Newer?

## The plan

We do not need the actual dates. All we need is a yes/no: "was the source
modified after the backup?". Bash has two operators that compare modification
times of two files, and one of them answers exactly this.

| Test | True when |
|---|---|
| `a -nt b` | a is **n**ewer **t**han b |
| `a -ot b` | a is **o**lder **t**han b |

## Building it

Name the paths, then ask the question from the source's point of view:

```bash
source_file="$1"
backup="$2"
if [[ $source_file -nt $backup ]]; then
  echo "STALE: $backup is older than $source_file"
else
  echo "fresh: $backup is up to date"
fi
```

Two subtleties are worth understanding. First, equal timestamps are neither
"newer" nor "older", so they land in the `else` branch, which the spec says is
fresh. Second, when the backup does not exist at all, `-nt` is true as long as the
source exists. The test treats a missing file as infinitely old, and that is what
we want: a backup that was never made is stale. No separate `-e` check needed.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

source_file="$1"
backup="$2"

if [[ $source_file -nt $backup ]]; then
  echo "STALE: $backup is older than $source_file"
else
  echo "fresh: $backup is up to date"
fi
```

## Try it by hand

```bash
touch -t 202401010000 old.bak
touch data.sql
./solution.sh data.sql old.bak
./solution.sh old.bak data.sql
```

## An alternative

`[[ $backup -ot $source_file ]]` says the same thing the other way round, but
it is false for a missing backup (the missing file is not "older" than anything), so
you would need an extra `! -e` check. Choosing `-nt` from the source's side gets
that case for free.
