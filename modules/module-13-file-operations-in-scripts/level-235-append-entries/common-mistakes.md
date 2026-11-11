# Common Mistakes

- **Using `>` out of habit.** Every run then erases the history and the log only ever has one line.
  - Wrong: `echo "[$stamp] $level: $*" > ops.log`
  - Right: `echo "[$stamp] $level: $*" >> ops.log`
- **Forgetting to `shift`.** The level then appears twice, once as the level and once inside the message.
  - Wrong: `level=$1; echo "[$stamp] $level: $*" >> ops.log`
  - Right: `level=$1; shift; echo "[$stamp] $level: $*" >> ops.log`
- **Using `$@` inside a longer string.** It does not give a single clean sentence and shellcheck rightly complains.
  - Wrong: `echo "[$stamp] $level: $@" >> ops.log`
  - Right: `echo "[$stamp] $level: $*" >> ops.log`
- **Forgetting the `+` in the date format.** `date '%Y-%m-%d'` is an error, not a format.
  - Wrong: `stamp=$(date '%Y-%m-%d %H:%M:%S')`
  - Right: `stamp=$(date '+%Y-%m-%d %H:%M:%S')`
