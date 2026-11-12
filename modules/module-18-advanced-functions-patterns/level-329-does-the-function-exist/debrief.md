# Debrief: Does the Function Exist?

Names in Bash live in several separate worlds: variables, functions, aliases,
builtins and programs on the PATH. When a script calls something whose name is
built at run time, the important question is "does *this* kind of thing exist
under this name?". `declare -F` is the precise question for functions.

## Under the hood

`declare -F` lists function names (without bodies; lowercase `-f` prints the
bodies). With a name argument it succeeds only if that function is defined.
A shell function is checked in its own table, so no variable or program can fool
it. The result travels as an exit status, and shell code treats statuses
as truth values: that is why you can put the command straight into an `if`
and send the printed name to `/dev/null`.

## The soft-failure pattern

The level's design matters as much as its test. A missing check is reported
and skipped; the rest of the run continues; the exit status says "not
everything went fine". That is nicer for the person on call than aborting, and
more honest than printing nothing. The alternative, letting "command not
found" (status 127) surface in the middle of a run, leaves the result half
done.

## In real work

Optional hooks (`if declare -F on_start; then on_start; fi`), plugin
contracts (does the plugin define what it must?), and CLI subcommand lookup all
begin with this test.

## Going further

Existing is not the same as allowed. Next, names that come from outside
must also be on a list you wrote.
