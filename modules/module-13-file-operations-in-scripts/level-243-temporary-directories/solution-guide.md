# Walkthrough: Temporary Directories

## The plan

Build the package in a private workshop, then ship only the tarball. The
workshop is created by `mktemp -d` and deleted by a trap, so nothing is
left behind and two runs can never collide.

## Step by step

`mktemp -d` is `mktemp` for folders: it creates an empty directory with an
unpredictable name and prints the path.

```bash
stage=$(mktemp -d)
trap 'rm -rf "${stage:?}"' EXIT
```

The trap is registered immediately, before anything can go wrong. The
`${stage:?}` is a belt-and-braces guard from the previous level's lesson:
if `stage` were ever empty, the shell aborts instead of running `rm -rf ""`.

Copy the wanted pages with a glob loop. `nullglob` makes an empty match
disappear rather than stay as a literal `*.html`; `${page##*/}` gives the bare
file name; names starting with `draft-` are skipped:

```bash
for page in "$site"/*.html; do
  name=${page##*/}
  [[ $name == draft-* ]] && continue
  cp "$page" "$stage/$name"
  echo "$name" >> "$stage/MANIFEST"
  count=$(( count + 1 ))
done
```

To get bare names in the archive, `tar` must run *inside* the stage. A
subshell keeps the `cd` from affecting the rest of the script, and the
output path must be absolute because we are about to move:

```bash
out="$PWD/release.tar"
( cd "$stage" && tar -cf "$out" -- * )
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then echo "usage: solution.sh SITE" >&2; exit 2; fi
site=$1
[[ -d $site ]] || { echo "no such folder: $site" >&2; exit 1; }

stage=$(mktemp -d)
trap 'rm -rf "${stage:?}"' EXIT

shopt -s nullglob
count=0
for page in "$site"/*.html; do
  name=${page##*/}
  [[ $name == draft-* ]] && continue
  cp "$page" "$stage/$name"
  echo "$name" >> "$stage/MANIFEST"
  count=$(( count + 1 ))
done
if (( count == 0 )); then
  echo "no pages to pack in $site" >&2
  exit 1
fi

out="$PWD/release.tar"
( cd "$stage" && tar -cf "$out" -- * )
echo "packed $count pages into release.tar"
tar -tf release.tar | sort
```

## Try it by hand

```bash
mkdir site; echo hi > site/index.html; echo x > site/draft-a.html
./solution.sh site
```

## An alternative

You could create a folder with a fixed name such as `build/` and delete it
by hand at the end. That works until two runs overlap, until the script
dies early, or until someone puts something precious in `build/`. A fresh
`mktemp -d` per run removes all three problems.
