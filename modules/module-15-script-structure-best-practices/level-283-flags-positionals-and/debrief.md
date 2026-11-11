# Debrief: Flags, Positionals and --

Argument parsing is a small state machine. At every step the loop looks at the
first unconsumed argument, takes the action that matches it, and `shift`s it off, so
the next iteration sees the next one. The parameters are a queue; `$#` says how many are
left; `shift N` pops N at once. When the loop breaks, the queue holds exactly the
arguments that are not options.

The `--` convention exists because data can look like options. A file called `-rf`,
a customer called `-p`, a search term `--help`: after `--`, nothing is an option any
more. This is not specific to your script; `rm -- -rf`, `grep -- -x file` and `git
checkout -- file` use the same rule, and well-behaved scripts should honour it too and
pass it on to the commands they call.

Three habits turn this into a pleasant interface. Check `$#` before reading `$2`
(or `set -u` aborts with an unhelpful message). Reject unknown options explicitly
instead of treating them as words. And send errors to stderr with status 2.

Going further: when a tool has several jobs, each with its own options, the first
positional becomes a command word. That is the subject of level 284.
