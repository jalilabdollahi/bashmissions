# Walkthrough: Find the Project Config

## The plan

This is the search `git` does to find `.git`: start where you are, test the
current folder, move to its parent, repeat. Two things must be right for the loop
to be correct: the paths must be comparable, and the loop must have a guaranteed
end.

## Building it

Comparable paths first. `work/apps/../apps/web` and `work/apps/web` are the same
place with different spellings, so turn both arguments into canonical absolute
paths:

```bash
start=$(cd "$1" 2>/dev/null && pwd -P) || { echo "not a directory: $1" >&2; exit 2; }
```

`cd` fails for a non-directory, and the `||` turns that into our own message
(without it, `set -e` would stop the script with nothing helpful). Do the same for
the root, then reject a start that is neither the root nor under it with
`[[ $start == "$root"/* ]]`.

Now the climb:

```bash
dir=$start
while true; do
  [[ -f $dir/.lanternrc ]] && { found=$dir; break; }
  [[ $dir == "$root" ]] && break
  dir=$(dirname "$dir")
done
```

The second test is the safety net: since START is inside ROOT, repeated `dirname`
must reach ROOT, where we stop. `-f` accepts only regular files, so a directory
named `.lanternrc` is skipped.

When `found` is empty, print the error and exit 1. Otherwise read the `project`
value with the usual `IFS='=' read -r key value` loop, trimming blanks, and print
the location. `${found#"$root"}` removes the root prefix, leaving `""` or
`/apps/web`, so `.${found#"$root"}/.lanternrc` gives `./apps/web/.lanternrc`.

## Trying it by hand

```
mkdir -p t/a/b && echo project=demo > t/a/.lanternrc
./solution.sh t/a/b t
```

## Alternative

A `for` loop with `${dir%/*}` also climbs, but it does not stop at a root and is
easy to leave running at `/`. The `while` with an explicit boundary is safer.
