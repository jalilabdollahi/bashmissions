# Debrief: Check the Status

Every process that ends hands one small integer back to whoever started it. That
integer is the exit status, and it is the only reliable way a script learns what
happened. Zero means success; any other value means "something else", and the
program decides which value means what. Bash stores the status of the most recent
command in `$?`.

Two details matter. First, `$?` is volatile. Any command, including `echo` and
`[[ ]]`, replaces it, so copy it into a variable straight away if you need it
twice. Second, the number carries more than pass/fail. grep uses 1 for "ran fine,
found nothing" and 2 for "could not do its job". A script that only asks "did it
fail?" cannot tell a quiet site from a missing file.

You have been using statuses all along: `if cmd; then` tests whether `$?` would
be zero. Now you can read the number itself.

In real work this is the foundation of every monitoring check: Nagios-style
probes, CI steps and cron wrappers all communicate through exit codes, not text.
Theo's wrong-folder disaster started with a command that failed quietly while the
script kept going.

Going further: reading `$?` by hand after every line gets tedious. The next level
shows the shortest guard: `cmd || exit 1`.
