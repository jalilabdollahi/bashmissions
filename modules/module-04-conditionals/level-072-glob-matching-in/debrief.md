# Debrief: Glob Matching in [[ ]]

In Level 60 you quoted the right-hand side of `==` to keep it literal. Now you
do the opposite on purpose: left unquoted, it becomes a pattern, and a handful of
characters let you describe a whole family of names.

## Under the hood

The pattern syntax is the same one the shell uses for file names at the
command line, called globbing. `*` matches any string, `?` any single
character, and `[abc]` any one of the listed characters. Inside `[[ ]]` the
match is done against the string on the left. It never looks at the file system,
so `[[ $name == *.log ]]` works on names that do not exist.

The match must cover the entire string. `*.log` means "ends with .log", and
`log` alone does not match because there is no dot and no prefix. To say "contains
.log", wrap the pattern with stars on both sides: `*.log*`.

Beware of the reverse mistake from Level 60: quoting here switches wildcards off
and makes `"*.log"` match only the literal name `*.log`.

## Where it shows up

Sorting files by extension, recognising host names (`web-*`), skipping hidden
files (`.*`), and choosing behaviour from a prefix like `feature/*` in a branch
name.

## Going further

A ladder of patterns on one value is so common that Bash gives it its own
keyword. That is `case`, the next level.
