# Debrief: Create Exclusively

Many security bugs are not about bad data but about *timing*. "If the file is not
there, create it" reads as one thought but runs as two steps, and in the gap
anything can happen: a second copy of your script, a cron job, or an attacker who
has been waiting for exactly that name. The mental model: **never ask the
system about the world and then act on the answer; ask the system to act and tell
you whether it worked.**

Operating systems provide atomic "create or fail" primitives, and Bash exposes
the most useful one as noclobber. A redirection under `set -o noclobber` is
"create only if absent", decided inside the kernel, so of two simultaneous callers
exactly one wins. The same flag refuses symlinks, which neutralises the
planted-link trick from the previous level without any extra test.

You will see the pattern in lock files and PID files for cron jobs, in
"claim a task" queues, and in package managers writing lock files. Choose the
atomic primitive (`>` with noclobber, `mkdir`, `mktemp`, `ln`) rather than a
test followed by a write.

Remember the limits: noclobber protects *creation*. Updating an existing file
safely needs a temp file plus an atomic `mv`, and a stale lock after a crash
needs a policy of its own.

Going further: the last two levels shift from what scripts touch to what they
remember and print: secrets in memory and in logs.
