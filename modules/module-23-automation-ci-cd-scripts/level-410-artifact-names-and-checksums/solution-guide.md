# Walkthrough: Artifact Names and Checksums

## The plan
Release files travel without context, so their names must carry it, and a
manifest lets anyone verify them. The script validates its two inputs, renames
what needs renaming, and writes the manifest from the final state of the
folder.

## Steps
Validate with anchored regexes: a lowercase product name and a three-part
version. Everything else prints usage and exits 2 before touching any file.

Find the artifacts. If a glob matches nothing, Bash passes the pattern through
as literal text, so a plain `for f in dist/*.tar` would "process" a file called
`dist/*.tar`. `shopt -s nullglob` turns that case into an empty list:

```bash
shopt -s nullglob
tars=(dist/*.tar)
(( ${#tars[@]} > 0 )) || { echo "no artifacts in dist/" >&2; exit 1; }
```

Renaming uses parameter expansion. `${path##*/}` removes the longest prefix
ending in `/`, leaving the file name. The prefix test is what makes the script
idempotent:

```bash
base=${path##*/}
[[ $base == "$prefix"* ]] && continue
mv "$path" "dist/$prefix$base"
```

For the manifest, `cksum` gives `CRC size name` on every platform, which is
why it is used instead of `sha256sum` (macOS ships `shasum`, Linux ships
`sha256sum`). Run it inside `dist/` so the printed names have no directory,
and write to a temporary file first so a reader never sees half a manifest:

```bash
( cd dist && cksum "$prefix"*.tar > MANIFEST.tmp && mv MANIFEST.tmp MANIFEST.txt )
```

The parentheses run in a subshell, so your script's working directory is
unchanged afterwards. The glob sorts names, giving the sorted manifest for free.

## Try it by hand
```bash
mkdir -p dist; echo hello > dist/linux-amd64.tar
./solution.sh demo 1.0.0; cat dist/MANIFEST.txt
```

## Alternative
A `for` loop calling `cksum` per file and appending with `>>` works too, but
leaves a half-written manifest if the script dies partway. One `cksum` call into
a temp file, then `mv`, is all-or-nothing.
