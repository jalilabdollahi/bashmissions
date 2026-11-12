# Debrief: printf Over echo

`echo` is fine for a message you typed yourself. It is a trap for text that came
from somewhere else (a file name, a user, a log line), because its behaviour depends
on what the text says: a leading `-n` is an option, `-e` enables escape sequences, and
whether `\t` becomes a tab varies between bash, dash and the macOS `/bin/sh`. POSIX
itself calls echo's behaviour with such arguments unspecified.

`printf` separates *format* from *data*. The first argument is a template that you
write; everything after it is data substituted into the `%s`, `%d` and similar
slots. Because the data never plays the role of options or of a format, the output is
identical on every system. The golden rule is "no variable in the first position":
`printf "$msg"` turns any `%` in `$msg` into an instruction, which is both a bug and
a classic injection.

You will see `printf '%s\n' "$var"` as the idiom in every careful script, and
`printf '%s\0'` when file names must be separated by the one byte that cannot occur
in them. Bash also offers `printf -v name '%s' value` to fill a variable without a
subshell.

Going further: when a *file name* looks like an option for another command, not just
for echo, use `--` to end option parsing; level 283 makes that a feature of your
own scripts.
