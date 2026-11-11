# Common Mistakes

- **Forgetting `-r`.** `read title` turns `C:\backups\nightly` into
  `C:backupsnightly`. Right: `read -r title`.
- **Putting a dollar sign on the target.** `read -r $title` tries to assign to
  whatever the (empty) variable contains. Right: `read -r title`, no `$`.
- **Expecting one `read` to take everything.** With two lines on stdin a single
  `read` returns only the first. Looping over all lines is level 53.
- **Using `echo` for the input.** `title=$(echo)` does not read stdin; `echo`
  prints, it does not read. Reading is `read`.
