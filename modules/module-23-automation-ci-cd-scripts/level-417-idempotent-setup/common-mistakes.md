# Common Mistakes

- **Loose line matching.** Wrong: `grep -q "umask 027" profile` matches `# umask 027` and `umask 0277`, so the real setting is never added. Right: `grep -qxF -- "umask 027" profile`.
- **Overwriting seed files.** Wrong: `echo PORT=8080 > config.env` on every run destroys the customer's edits. Right: write only when `[[ ! -e $config ]]`.
- **Appending twice.** Wrong: `echo "umask 027" >> profile` unconditionally; each run adds another copy. Right: test first.
- **Gluing onto the last line.** Wrong: appending to a file without a final newline gives `export A=1umask 027`. Right: check `tail -c1` and add a newline first.
- **`-e` for links.** Wrong: `[[ -e $link ]]` is false for a dangling symlink, so `ln -s` then fails. Right: `[[ -L $link ]]` for "is a link", and a separate `-e` check for conflicts.
