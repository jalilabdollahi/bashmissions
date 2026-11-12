# Common Mistakes

- **Locking too late.**
  Wrong: assigning the careless value first, then `readonly RETENTION_DAYS`. The lock then freezes the wrong value.
  Right: `readonly` goes on the line that sets the value you want to keep.
- **Trying to `unset` it to start over.**
  `unset RETENTION_DAYS` fails on a read-only variable. Pick the right value before you lock it.
- **Spaces around the equals sign.**
  Wrong: `readonly RETENTION_DAYS = $KEEP_DAYS` makes Bash complain that `=` is not a valid identifier.
  Right: `readonly RETENTION_DAYS=$KEEP_DAYS`.
- **Expecting the script to stop.**
  The refused assignment prints an error but the script continues, with the old value. If a failure must halt everything you will need to check for it, which comes later in the course.
