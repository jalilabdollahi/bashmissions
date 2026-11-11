# Debrief: Different String?

`!=` is the mirror image of `==`: true when the strings differ. Its real value
in operations is the guard clause. Rather than nesting your whole script inside
"if everything is right", you check each requirement at the top, complain and
exit when one fails, and let the remaining code assume it is safe.

## Under the hood

Two details matter here. First, `>&2` redirects the message to file descriptor 2,
standard error. Terminals show both streams, but pipelines and logs keep them
apart, so a refusal never ends up inside a report file. Second, `exit 1`
terminates the script right now. Exit status 0 means success; anything else
means "something went wrong", and a different number can say what. Callers such
as cron, CI pipelines and other scripts read that status.

Like `==`, the right side of `!=` is a pattern unless quoted. A plain word like
`dory` has no special characters, so no quotes are needed here.

## Where it shows up

"Only run as root", "only on the standby", "only from the main branch", "never
against production": every safety rail in an ops toolbox is a guard like this.

## Going further

Sometimes the thing to check is not which value it is, but whether there is a
value at all. Next level: empty strings.
