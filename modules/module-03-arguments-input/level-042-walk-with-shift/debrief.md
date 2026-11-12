# Debrief: Walk with shift

`shift` is the only command that *edits* the argument list. It removes `$1` and
renumbers everything else, so `$#`, `$*` and `"$@"` all change with it. The
mental model is a queue: take the front item, and the rest step forward.

That model is what makes many argument parsers simple. A script can say "read
the first word as a command, shift, and hand the remainder on", exactly like
`git commit -m "..."` hands `-m "..."` to a sub-tool. `shift 2` removes two at
once, which is how option parsers consume a flag together with its value
(you will do that in level 54).

Be careful with two details. The removed argument is gone for good, so keep
what you need first. And `shift` with nothing left to shift returns an error,
which `set -e` will treat as a failure, so count with `$#` before shifting in
scripts where arguments are optional.

Going further: you have been assuming the arguments exist. The next level adds
the polite behaviour for when they do not: a usage message and an exit code.
