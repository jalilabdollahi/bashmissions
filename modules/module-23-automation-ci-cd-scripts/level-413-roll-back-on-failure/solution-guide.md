# Walkthrough: Roll Back on Failure

## The plan
Symlink deploys are popular because the switch is a single cheap operation: every
release lives in its own folder, and `current` names the live one. The same
cheapness makes rollback trivial, provided you saved the previous target before
changing it. The script is: remember, switch, verify, and undo if verification
fails.

## Steps
Check the release exists first. A typo should change nothing:

```bash
release="releases/$version"
[[ -d $release ]] || { echo "no such release: $version" >&2; exit 2; }
```

Then record the old state. `readlink` prints the text stored in the link, which
is exactly what you need to restore it later. A first deploy has no link, so
test for one:

```bash
previous=""
if [[ -L current ]]; then previous=$(readlink current); fi
```

(The `if` form is deliberate: `[[ -L current ]] && previous=...` as a last
statement would make `set -e` unhappy if it returned false.)

Switching uses `ln -sfn`. `-f` overwrites the old link and `-n` stops `ln` from
following the old link into its directory. Forget `-n` and you get a mysterious
symlink inside the old release.

```bash
ln -sfn "$release" current
rc=0; smoke-test || rc=$?
```

Now decide. On success report. On failure, restore from the saved text, or
remove the link if there was nothing to go back to:

```bash
if [[ -n $previous ]]; then ln -sfn "$previous" current; else rm -f current; fi
```

`${previous#releases/}` strips the folder prefix for the friendly message.

## Try it by hand
```bash
mkdir -p releases/v1 releases/v2; touch releases/v1/.healthy
ln -s releases/v1 current
./solution.sh v2; ls -l current     # v2 has no .healthy, so you are back on v1
```

## Alternative
Building a new link (`ln -s ... current.new`) and renaming it over `current` is
atomic, but `mv` on a directory symlink behaves differently on GNU and BSD.
`ln -sfn` is the portable choice, with a tiny window between unlink and link.
