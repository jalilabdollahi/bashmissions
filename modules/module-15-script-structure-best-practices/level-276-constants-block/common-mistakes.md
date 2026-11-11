# Common Mistakes

- **Keeping the environment fallback.** Wrong: `readonly BACKUP_ROOT=${BACKUP_ROOT:-/srv/backups}` still adopts the caller's value, then locks it in. Right: `readonly BACKUP_ROOT=/srv/backups`.
- **Declaring readonly after using the variable.** Wrong: `path=$ROOT/x` on line 5 and `readonly ROOT=...` on line 9; under `set -u` this crashes. Right: the block comes first.
- **Assigning a readonly variable again.** Wrong: `KEEP_DAYS=30` later in the file gives "readonly variable" and, with `set -e`, ends the script. Right: use a different, ordinary variable for a computed value.
- **Leaving one literal behind.** Wrong: `echo "keep=14 days"` next to a `KEEP_DAYS` constant; the two drift apart. Right: `echo "keep=$KEEP_DAYS days"`.
- **Using lower-case names.** Wrong: `readonly root=/srv/backups`, which looks like any scratch variable. Right: upper case signals a constant.
