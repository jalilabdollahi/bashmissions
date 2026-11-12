# Common Mistakes

- **Parsing `ls`.** Wrong: `ls -t dir | tail -n +4 | xargs rm` splits `release notes.tar` into `release` and `notes.tar`. Right: a glob into an array, and `rm -- "$path"` per element.
- **Forgetting `--`.** Wrong: `rm "$path"` for a file named `-rf` is read as options. Right: `rm -f -- "$path"`.
- **Unmatched glob.** Wrong: in an empty folder the loop runs once with the text `dir/*` and `rm` complains (or worse). Right: `shopt -s nullglob`.
- **No rule for ties.** Wrong: two files with the same timestamp both get rank 0, so you keep more than KEEP. Right: break ties by name so exactly KEEP files survive.
- **Deleting what is not an artifact.** Wrong: `rm -rf "$dir"/*` also removes folders and follows symlinks. Right: test `-f` and `! -L` and delete only those.
