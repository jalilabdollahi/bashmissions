# Walkthrough: Path Traversal Guard

## The plan
Treat `NAME` as hostile text that will be glued to `public/`. Refuse every shape
that can leave that folder, then fall back to the ordinary "does it exist" check.

## How the attack works
`public/../private/keys.txt` is a perfectly good path: the OS resolves `..` as
"parent folder" and lands in `private`. An absolute name such as `/etc/hosts`
works differently (`public//etc/hosts` is still under public, but a script that
uses the name directly, or `cd "$name"`, escapes at once), so we refuse it too.

## Why not just reject two dots?
`*..*` also blocks `summary..final.txt`, a legitimate file. The only dangerous
form is a component that is *exactly* `..`, which means one of four shapes:

| shape | pattern |
|---|---|
| the whole name | `..` |
| at the start | `../*` |
| in the middle | `*/../*` |
| at the end | `*/..` |

## Steps
1. Usage check (exit 2).
2. The `case` with the empty name, `/*` and the four shapes: print
   `denied: NAME`, exit 1.
3. `[[ -f public/$name ]]` for existence; message `not found: NAME`.
4. `cat -- "public/$name"`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1
case $name in
  ""|/*|..|../*|*/../*|*/..)
    printf 'denied: %s\n' "$name" >&2
    exit 1
    ;;
esac
file="public/$name"
if [[ ! -f $file ]]; then
  printf 'not found: %s\n' "$name" >&2
  exit 1
fi
cat -- "$file"
```

## Try it
```
mkdir -p public private; echo hi > public/a.txt; echo secret > private/k
./solution.sh a.txt
./solution.sh ../private/k
```

## Alternative
Resolve the path (`cd` and `pwd -P`) and check the result starts with the
public folder, as the delete guard did in the file-handling module. That also
catches symlinks, but it only works for paths that exist and does more work.
Rejecting the shape first is simple, fast and independent of the disk; the
two approaches are often combined.
