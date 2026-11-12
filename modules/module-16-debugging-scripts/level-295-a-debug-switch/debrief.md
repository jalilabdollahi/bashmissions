# Debrief: A DEBUG Switch

Print statements are the oldest debugging tool there is, and the cheapest. The
trouble is that they are either always on (noise) or removed after the bug (and
needed again next month). A debug switch keeps them in the code and lets the
caller decide.

The pattern has three parts: an environment variable that the caller sets for a
single run (`DEBUG=1 ./script`), a small function that checks it, and messages
that go to stderr so they never corrupt the script's real output. Because the
variable is set on the command line, it exists only for that process: no files
to edit, nothing to remember to switch off.

The function is also a classic lesson in how strict mode and short-cuts
interact. `[[ ${DEBUG:-} == 1 ]] && echo ...` looks tidy, but when the test is
false the last command's status is 1, so the function returns 1, and under
`set -e` the script stops for no visible reason. A plain `if` has status 0
when nothing runs. The `:-` default exists for the same defensive reason: with
`set -u`, reading a variable that was never set is an error.

You will find this in almost every serious shell project: `DEBUG`, `VERBOSE`,
`TRACE` flags and `log_debug` helpers.

Going further: the next levels put position information into messages, starting
with the line number of the command that is talking.
