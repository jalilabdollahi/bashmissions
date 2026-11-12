# Debrief: The CLI Framework

The step from "a script with options" to "a command-line framework" is a step from code
to **data**. Once the commands live in a registry, every user-visible behaviour that used to be
copy-pasted (parsing, help, validation, error messages) is written exactly once, so it is
consistent by construction. Real frameworks (git's subcommand tables, Cobra, Click, argparse) all work
this way; yours is thirty lines of Bash.

Convention matters as much as code. Exit status 64 for usage errors and 1 for failures; messages
prefixed with the program name; errors on stderr, help on stdout when asked and on stderr when
you were called with nothing; `--` to end option parsing; long options with both `--opt value` and
`--opt=value`; a flag beats an environment variable beats a default. Users never read your source, so
these conventions are the interface.

The "did you mean" hint is a good lesson in proportionate cleverness: a subsequence test is ten lines,
has no dependencies, and fixes the most common typos (dropped letters). Full edit distance would be more
code than the rest of the parser for a small gain.

Going further: the next level is the configuration layer such a tool needs: loading settings from several
places, validating them and merging them in the right order.
