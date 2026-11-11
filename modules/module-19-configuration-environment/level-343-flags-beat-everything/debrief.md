# Debrief: Flags Beat Everything

The mental model: **the closer a choice is to the moment of the run, and the more
deliberate it is, the more weight it gets.** Defaults are the author's guess, the
file is the administrator's habit, the environment is the context of this
session, and a flag is somebody typing exactly what they want right now. That is
why the order is flag, env, file, default, and why it is the same order in
`git`, `ssh`, `curl`, `docker` and nearly everything else you use.

The implementation lesson is separation: gather first, decide afterwards. If you
resolve each layer the moment you meet it, the order of your code and the order of
the command line start fighting (a `--config` that comes last on the line, for
instance). With each layer in its own array, the precedence lives in one small
`if / elif` chain you can read and test, and showing the source of each value
comes free. That "(flag)" or "(file)" label is the most useful debugging output a
configurable program can have.

Under the hood, `case` patterns are globs, not regexes, so `--dest=*` matches
anything after the equals sign, and `shift N` drops N arguments from `$@`.

Going further: some settings are mandatory, and no layer may supply them. The next
level checks required keys and, instead of stopping at the first missing one,
reports all of them in a single run.
