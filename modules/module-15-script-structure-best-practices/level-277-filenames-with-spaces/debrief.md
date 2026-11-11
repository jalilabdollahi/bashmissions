# Debrief: Filenames with Spaces

The rule is short and absolute: **unquoted expansions are a request for splitting and
globbing**. After bash substitutes a variable, it chops the result into words at every
space, tab or newline (word splitting), and then treats any word containing `*`, `?` or
`[` as a pattern to match against files (pathname expansion). Double quotes suppress
both. So `cp $f dest` really means "run cp with however many words `$f` happens to
contain", while `cp "$f" dest` always means "one word".

Globs are the one place where quotes need thought. `"$dir"/*.txt` quotes the part that
is data (the directory), and leaves the part that is a pattern (`*.txt`) for the shell.
When the pattern matches, bash returns one word per file name, so the loop variable is
safe; when it matches nothing, the pattern is passed through unexpanded, hence the
`[ -e ]` guard.

This is not an edge case. Users have spaces, version control has `*` in branch names, and
a file called `-rf` has caused real incidents. Scripts that quote everywhere need no
special-casing for them.

Going further: quoting protects single values. When you need to build a whole *command*
out of pieces, even quotes are not enough; level 278 introduces arrays for that.
