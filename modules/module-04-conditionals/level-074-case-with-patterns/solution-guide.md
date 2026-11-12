# Walkthrough: case with Patterns

## The plan

Last level each branch matched one exact word. Here the branches match shapes
of file names, and some of them cover several shapes. Two ideas make that work:

- A branch pattern may contain wildcards (`*`, `?`), exactly like file globs.
- Several patterns separated by `|` share one branch: "this or that".

The order matters because `case` runs the first matching branch only.

## Building it

Keep the argument, then open the case on the whole name. No quotes are needed on
the patterns; quote the word being tested:

```bash
file="$1"
case "$file" in
```

Both `.tar.gz` and `.tgz` are the same kind of archive, so they share a branch:

```bash
  *.tar.gz | *.tgz)
    echo "extract with: tar -xzf $file"
    ;;
  *.tar)
    echo "extract with: tar -xf $file"
    ;;
  *.zip)
    echo "extract with: unzip $file"
    ;;
```

Now the trap. `site.tar.gz` ends in `.gz` as well. If the `*.gz` branch came first,
every tarball would be treated as a single gzipped file. So `*.gz` goes after
`*.tar.gz`:

```bash
  *.gz)
    echo "extract with: gunzip $file"
    ;;
  *)
    echo "unknown archive type: $file" >&2
    exit 1
    ;;
esac
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

file="$1"

case "$file" in
  *.tar.gz | *.tgz)
    echo "extract with: tar -xzf $file"
    ;;
  *.tar)
    echo "extract with: tar -xf $file"
    ;;
  *.zip)
    echo "extract with: unzip $file"
    ;;
  *.gz)
    echo "extract with: gunzip $file"
    ;;
  *)
    echo "unknown archive type: $file" >&2
    exit 1
    ;;
esac
```

## Try it by hand

```bash
for f in a.tar.gz b.tgz c.gz d.zip e.txt; do ./solution.sh "$f"; done
```

## An alternative

A chain of `[[ $file == *.tar.gz || $file == *.tgz ]]` conditions works but
repeats the variable on every line. In `case`, the shapes line up in a column
and the reader can scan them at a glance.
