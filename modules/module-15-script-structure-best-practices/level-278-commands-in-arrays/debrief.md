# Debrief: Commands in Arrays

A shell command is not a string; it is a *list of words*. The shell parses a line
into that list and hands it to the program, and quotes are how you tell the parser
where words begin and end. If you save a command as text you throw the structure
away, and re-parsing it later guesses wrong whenever data contains spaces, stars or
quotes. An array keeps the structure: each element is exactly one argument, forever.

`"${args[@]}"` is the array twin of `"$@"`: it expands to one word per element, with
no splitting and no globbing. `args+=( ... )` appends elements, so options can be
added conditionally while the script runs: only add `--exclude` if the user asked for
it, only add `-v` in verbose mode. Parentheses are a nice example: in the array they
are quoted once, `'('`, so the shell leaves them alone and `find` receives a bare `(`.

This is the safe replacement for `eval` and for sprinkling `$opts` unquoted. You will
see it in deployment scripts that assemble `docker run` or `rsync` lines, and in any
wrapper that forwards user-supplied arguments to another program.

Going further: when the data itself looks like an option, such as a file called
`-n`, arrays are not enough; level 279 looks at `printf`, and level 283 at `--`.
