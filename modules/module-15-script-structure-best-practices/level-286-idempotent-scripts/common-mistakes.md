# Common Mistakes

- **Appending blindly.** Wrong: `echo "$name" >> sites.list` on every run produces duplicates. Right: test with `grep -qxF -- "$name" sites.list` first.
- **Using grep without -x.** Wrong: `grep -q gull sites.list` is satisfied by `gull-and-anchor`, so the real entry is never added. Right: `-x` for the whole line.
- **Using grep without -F.** Wrong: a name such as `a.b` is treated as a regex and matches `axb`. Right: `-F`.
- **Overwriting with `>`.** Wrong: `echo ... > index.html` replaces what the customer edited. Right: write only when `[ ! -e file ]`.
- **Letting "already exists" be an error.** Wrong: plain `mkdir dir` exits 1 on a second run and `set -e` ends the script. Right: test first or use `mkdir -p`.
