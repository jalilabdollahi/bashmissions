# Walkthrough: The Release Manager

## The plan
A release has a few irreversible effects (a tag others can pull, a message people read) and several
reversible ones (files on disk). Good release tooling does the reversible work first, does the
irreversible work as late as possible, and can undo the reversible part when the irreversible
part fails. That ordering is the backbone of the script. The version number itself is not chosen,
it is *derived*: commit subjects follow a convention, so the highest-impact commit decides the bump.

## Step by step
1. **Arguments.** `--dry-run`, `--notify URL`, one APP. A small `fail MESSAGE [CODE]` helper keeps
   the error branches to one line each.

2. **Preflight.** `git status --porcelain` must print nothing. `git describe --tags --abbrev=0`
   gives the base; its failure is not an error but "this is the first release" (base `v0.0.0`, range
   `HEAD` instead of `TAG..HEAD`). A tag that is not `vN.N.N` is refused because arithmetic on it
   would be guesswork. No commits in the range exits 4: there is nothing to say.

3. **Classifying.** One regex in a variable, `^([a-z]+)(\(([^)]*)\))?(!)?: (.+)$`, captures type, scope,
   bang and text through `BASH_REMATCH`. A `!` is breaking, `feat` and `fix` get their own lists,
   everything else, including commits that do not follow the convention at all, goes to `other`
   with its full subject so no information is dropped.

4. **Semantic version.** Highest wins: any breaking commit bumps MAJOR (and resets the rest), else any
   feature bumps MINOR, else PATCH. Write it as an `if / elif / else` on the array sizes.

5. **Dry run.** After all preflight and computation, print what would happen and the generated
   section and stop. Because `render_section` is a function, the preview and the real changelog
   cannot disagree.

6. **Artifacts.** `tar -czf ... -C dist .` packages the files; the sums file lists `CRC SIZE PATH`
   per file from `cksum < file`, in sorted order so it is reproducible.

7. **Changelog.** Written to `CHANGELOG.md.new` as header, new section, then
   `tail -n +3` of the old file (skipping its header). The old file is untouched until the tag exists.

8. **Tag, then commit.** If `git tag` fails (somebody else just released) delete the tarball, the
   sums and the new changelog and exit 5. If it works, `mv` the new changelog over the old one.

9. **Announce.** A failed webhook is a warning only: the release exists and must not be
   "undone" because a chat service was down.

## Try it by hand
```
RELEASE_DATE=2026-11-12 ./solution.sh --dry-run shrimp-api
```

## Alternative
Letting the person type the version removes the parsing, and also the guarantee: the next breaking
change will be shipped as a patch release the day somebody is tired. Deriving it keeps the
convention honest because breaking a commit message now has consequences.
