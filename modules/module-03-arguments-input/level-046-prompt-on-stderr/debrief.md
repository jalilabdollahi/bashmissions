# Debrief: Prompt on stderr

Programs have two output streams for a reason: stdout is the *result* that other
programs may consume, stderr is *conversation with the human*. A prompt is
conversation. If it went to stdout, the next program in a pipeline would receive
`Server to restart: ` as data. `read -p` gets this right automatically.

There is a second subtlety, and the tests above depend on it: Bash prints the
prompt only when it is reading from a terminal. In a pipe or a cron job nothing
is displayed, which is exactly what you want for scripts that are used both
interactively and from other scripts.

Interactive questions are the easy part of user input. Real tools also decide how
to behave when nobody is there to answer: for an unattended run the right design
is usually to accept the value as an argument, which you will combine with `read`
in level 52.

Going further: the same `read` can split a line into several variables at once.
That is the next level.
