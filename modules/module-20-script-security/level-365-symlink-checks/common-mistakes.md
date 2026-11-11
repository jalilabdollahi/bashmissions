# Common Mistakes

- **Using `-f` or `-e` as the guard.** Wrong: `[[ -f $file ]] || exit` accepts a symlink to a regular file, and a dangling link looks like "no file". Right: `[[ -L $file ]]`.
- **Only checking the last component.** Wrong: `[[ -L notes/a.txt ]]` is false when `notes` is the link. Right: also test `dirname`.
- **Refusing after writing.** Wrong: appending first and then testing; the damage is done. Right: all checks first.
- **Forgetting `--` with dirname.** Wrong: `dirname "$file"` with a file called `-n/x` misreads an option. Right: `dirname -- "$file"`.
- **Treating the check as a lock.** Wrong: believing a passed `-L` test guarantees the path stays safe. The path can change after the test; for creation use the atomic approach of the next level.
