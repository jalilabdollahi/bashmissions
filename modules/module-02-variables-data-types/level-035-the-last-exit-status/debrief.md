# Debrief: The Last Exit Status

## What you learned
Every command ends with an exit status, a number from 0 to 255 where 0 means success. Bash stores the latest one in `$?`. It is a short-lived value: the next command replaces it, so save it if you need it later.

## Under the hood
After running a command Bash sets `$?` to its status. Assignments like `active_rc=$?` are themselves commands, and they set `$?` to 0 afterwards, but that is fine because you already captured the value. That is also why `echo "status: $?"` works only when the command you care about came right before it.

Exit statuses are the shell's only built-in way for programs to say "it worked" or "it did not". You met `exit N` in module 1 when your own scripts reported results; here you read the same kind of number from someone else's command.

## In real work
Deploy scripts check the status of `rsync`, `grep -q`, `ping`, `tar`. Cron mails you when a job exits non-zero, CI marks a build red. Programs such as `grep` use 1 for "nothing found" and 2 for "real error", which is a difference worth reporting separately.

## Going further
You now have a decision value but no way to act on it yet. Module 4 turns statuses into `if` statements and `&&`/`||` chains.
