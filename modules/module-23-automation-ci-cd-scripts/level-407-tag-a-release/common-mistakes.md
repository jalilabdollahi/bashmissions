# Common Mistakes

- **Testing the exit status of `git status`.** Wrong: `if git status --porcelain; then` is true even for a dirty tree, because the command succeeds either way. Right: look at its output with `[[ -n $(git status --porcelain) ]]`.
- **Using `git tag NAME`.** Wrong: a lightweight tag has no message, and `git describe` skips it without `--tags`. Right: `git tag -a NAME -m "..."`.
- **Letting `rev-parse` print.** Wrong: `if git rev-parse --verify "refs/tags/$tag"; then` leaks a hash into the script's output. Right: add `-q` and `>/dev/null`.
- **Checking after tagging.** Wrong: tag first, then notice the tree was dirty, leaving a bad tag behind. Right: all guards first, `git tag` after them.
- **Hiding a failed push.** Wrong: `git push origin "$tag" || true` reports success for a release that never left the laptop. Right: report it and say how to remove the local tag.
