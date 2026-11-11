# Debrief: Replace eval

`eval` has one job: take text and run it as shell code. That is exactly the
power an attacker wants, so any value that can reach an `eval` line, even
indirectly through a file or a config key, is a remote code execution bug
waiting for the right input. The mental model to keep: **a string is data; a list
of words is a command.** The moment you glue data into a string and re-parse it,
you give the data a vote on what the command is.

Arrays remove the need. `grep "${flags[@]}" ...` hands grep a finished argument
vector. The shell performs no second parse, so a `;` inside `$pattern` is just a
character grep looks for. `case` adds the second defence: users pick from words
you listed, and you decide what each word means.

The same idea replaces other "run this text" tricks: `bash -c "$string"`,
`sh -c`, and building `ssh host "cmd $arg"` lines. When a second shell is truly
unavoidable (ssh), pass data as separate arguments and quote them with
`printf %q`.

Real tools follow this pattern: a deploy wrapper that maps `--env prod` to a
known config path, never `source`-ing or evaluating whatever env name arrives.

Going further: a `case` only works when the list of good values is short and
written in the script. Level 357 moves the list to a file and makes "known
good" the rule for everything.
