# Common Mistakes

- **A space between the number and the operator.** The shell reads `2` as an argument.
  - Wrong: `nightly-backup "$site" 2 > backup-errors.log` (passes "2" to the tool and redirects stdout)
  - Right: `nightly-backup "$site" 2> backup-errors.log`
- **Using plain `>` and wondering why the warnings still show.** `>` is `1>`.
  - Wrong: `nightly-backup "$site" > backup-errors.log` (progress in the file, warnings on screen)
  - Right: `nightly-backup "$site" 2> backup-errors.log`
- **Expecting the file to be missing when there are no errors.** The shell creates it before the command runs.
  - Symptom: an empty backup-errors.log after a clean run; check `[[ -s file ]]` to test "has content"
- **Redirecting both by mistake with `&>`.** That sends the progress into the file too.
  - Wrong: `nightly-backup "$site" &> backup-errors.log`
  - Right: only `2>`
