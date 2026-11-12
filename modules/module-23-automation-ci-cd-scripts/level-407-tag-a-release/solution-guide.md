# Walkthrough: Tag a Release

## The plan
Tagging is the one step in a release you cannot quietly undo once it is
pushed. So the script is mostly *guards*: refuse early, change state last.

## Steps
Normalise the input. The optional `v` is part of the regex, the numbers are a
capture, and the tag is rebuilt from the capture so `1.5.0` and `v1.5.0` agree:

```bash
[[ $version =~ ^v?([0-9]+\.[0-9]+\.[0-9]+)$ ]] || { ...; exit 2; }
tag="v${BASH_REMATCH[1]}"
```

Guard one: a clean tree. `git status --porcelain` is meant for scripts, its
format never changes between git versions and it is empty when nothing is
modified or untracked:

```bash
if [[ -n $(git status --porcelain) ]]; then echo "working tree is not clean" >&2; exit 1; fi
```

Guard two: the name must be new. `git rev-parse -q --verify refs/tags/NAME`
communicates only through its exit status (0 = found), so use it directly as the
`if` condition and discard the printed hash:

```bash
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then ...; fi
```

Now the real work. `-a` makes an annotated tag (a full object with author,
date and message, which is what release tooling expects) and `-m` supplies the
message without opening an editor:

```bash
git tag -a "$tag" -m "Release $tag"
```

Pushing can fail for reasons nobody controls (network, permissions). When it
does, the tag now exists only locally, so the error tells the operator exactly
how to clean up. `if ! git push ...; then` gives you that branch without
`set -e` ending the script first.

## Try it by hand
The stub keeps its state in files in your workspace:
```bash
echo v1.4.0 > .git-tags
./solution.sh 1.5.0; cat .calls.log
```

## Alternative
`git tag` without `-a` makes a lightweight tag (just a pointer). It works, but
it carries no message or tagger, and `git describe` ignores lightweight tags
unless you add `--tags`.
