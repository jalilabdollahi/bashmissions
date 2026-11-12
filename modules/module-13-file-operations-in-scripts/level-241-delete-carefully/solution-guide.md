# Walkthrough: Delete Carefully

## The plan

`rm -rf` has no undo, so the script is mostly *checks*. The delete itself is
the last, boring line. We reject bad input from most obvious to most subtle.

## Why the empty variable matters

Try this harmless experiment (note the `echo` in front):

```bash
dir=""
echo rm -rf "$dir/"*
```

The shell expands `"$dir/"*` to `/*`, every top-level folder of the system,
and prints `rm -rf /bin /etc /home ...`. Without the `echo` that is a
catastrophe. The same happens when a variable was never set. So: never feed
an unchecked variable to `rm`.

## Step by step

Obvious input errors first: no argument, empty string, `/`, or not a folder.

```bash
[[ -z $dir ]]   && { echo "refusing: empty path" >&2; exit 2; }
```

Then the subtle part: `shared/../secret` *looks* like it is inside
`shared`. We cannot judge by text, so we ask the file system where it
really is:

```bash
base="$(pwd -P)/shared"
resolved=$(cd "$dir" && pwd -P)
```

`cd` follows the path (including `..` and symlinks) and `pwd -P` prints the
real place. Now compare. The shared folder itself is refused, and anything
else must start with `base/`. Adding a slash before matching avoids treating
`shared-old` as a sibling inside `shared`:

```bash
case "$resolved/" in
  "$base"/*) ;;
  *) echo "refusing: $dir is outside shared" >&2; exit 1 ;;
esac
```

Finally: `rm -rf -- "$resolved"` (`--` ends option parsing, in case a path
starts with a dash) and the confirmation line.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

# Check 1: an empty value must never reach rm. "$dir/" would become "/".
if [[ -z $dir ]]; then
  echo "refusing: empty path" >&2
  exit 2
fi
if [[ $dir == / ]]; then
  echo "refusing: that is the root folder" >&2
  exit 1
fi
if [[ ! -d $dir ]]; then
  echo "refusing: $dir is not a folder" >&2
  exit 1
fi

# Real, absolute locations: ".." and symlinks are gone after pwd -P.
base="$(pwd -P)/shared"
resolved=$(cd "$dir" && pwd -P)

if [[ $resolved == "$base" ]]; then
  echo "refusing: that is the shared folder itself" >&2
  exit 1
fi
# The trailing slashes make sure "shared-old" is not mistaken for "shared".
case "$resolved/" in
  "$base"/*) ;;
  *)
    echo "refusing: $dir is outside shared" >&2
    exit 1
    ;;
esac

rm -rf -- "$resolved"
echo "deleted: $dir"
```

## Try it by hand

```bash
mkdir -p shared/scratch secret
./solution.sh shared/../secret ; echo "exit $?"
./solution.sh shared/scratch
```

## An alternative

`rm -rf "${dir:?}"` aborts the script if `dir` is empty or unset, a handy
last safety net. It does not know about `/` or `..`, so it complements the
checks; it cannot replace them.
