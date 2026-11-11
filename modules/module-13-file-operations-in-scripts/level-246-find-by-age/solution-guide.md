# Walkthrough: Find by Age

## The plan

Two `find` commands over the same tree, one with a calendar test and one
with a reference-file test, both restricted to regular files and both
skipping the marker.

## Step by step

**Calendar age: `-mtime`.** `-mtime +30` means "last modified more than 30
days ago". The days are counted in whole 24-hour periods, so `+30` really
means 31 or more. `-mtime -30` is "within the last 30 days" and plain `30` is
"exactly that many days old".

```bash
old=$(find "$folder" -type f ! -name .last-backup -mtime +"$days" | sort)
```

**Relative age: `-newer`.** `-newer FILE` is true for entries modified more
recently than FILE. It does not look at the clock at all, so it answers "what
changed since X happened" for any X that left a file behind:

```bash
changed=$(find "$folder" -type f ! -name .last-backup -newer "$marker" | sort)
```

`! -name .last-backup` ("not named") keeps the marker out of the first list;
the second list never contains it, because a file is not newer than itself.

Both lists may be empty, so printing needs a guard (an empty string would
produce one empty line), and each line gets its prefix and is counted:

```bash
if [[ -n $old ]]; then
  while IFS= read -r path; do
    echo "old: $path"
    old_count=$(( old_count + 1 ))
  done <<< "$old"
fi
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh FOLDER DAYS" >&2
  exit 2
fi
folder=$1
days=$2
marker="$folder/.last-backup"

if [[ ! -f $marker ]]; then
  echo "no marker: $marker" >&2
  exit 1
fi

# -mtime +N: modified MORE than N whole days (N*24h) ago.
old=$(find "$folder" -type f ! -name .last-backup -mtime +"$days" | sort)

# -newer FILE: modified more recently than FILE. No clock involved, so
# it is also the right tool when "since when" is an event, not a date.
changed=$(find "$folder" -type f ! -name .last-backup -newer "$marker" | sort)

old_count=0
changed_count=0
if [[ -n $old ]]; then
  while IFS= read -r path; do
    echo "old: $path"
    old_count=$(( old_count + 1 ))
  done <<< "$old"
fi
if [[ -n $changed ]]; then
  while IFS= read -r path; do
    echo "changed: $path"
    changed_count=$(( changed_count + 1 ))
  done <<< "$changed"
fi

echo "summary: $old_count old, $changed_count changed"
```

## Try it by hand

```bash
mkdir up; touch up/.last-backup
touch -t 202001010000 up/ancient.txt      # an old date
sleep 1; echo new > up/fresh.txt
./solution.sh up 30
```

`touch -t YYYYMMDDhhmm` sets a modification time, which is the easy way to
test age logic.

## An alternative

You could compute a cut-off date and compare with `[[ -nt ]]` in a loop,
which works but means writing the walk yourself. `find` does the walking
and the comparing in one tool.
