# Common Mistakes

- **Tagging before the risky work.** Wrong: `git tag` first, then discover `dist/` is empty. Now a public tag points at nothing. Right: validate and build first, tag last, and roll back files if the tag fails.
- **Forgetting the first release.** Wrong: assuming `git describe` always works, so the script dies on a new project. Right: handle its failure as "no tag yet": base `0.0.0`, range `HEAD`.
- **Bumping the wrong part.** Wrong: bumping MINOR for a feature and leaving PATCH as it was (`1.5.2`). Right: a MINOR bump resets PATCH to 0, a MAJOR bump resets both.
- **Quoting the regex inline.** Wrong: `[[ $s =~ "^feat" ]]` (quoted means literal). Right: keep the pattern in a variable (`re=...; [[ $s =~ $re ]]`).
- **Editing the changelog in place.** Wrong: `sed -i` or `cat new old > CHANGELOG.md` before the tag exists, leaving a changelog for a release that never happened. Right: write `CHANGELOG.md.new`, `mv` it after the tag.
- **Failing the release for a webhook.** Wrong: `set -e` killing the script when `curl` fails after the tag exists. Right: test it in an `if` and warn.
