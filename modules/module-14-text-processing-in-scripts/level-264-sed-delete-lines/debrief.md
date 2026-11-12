# Debrief: sed Delete Lines

sed is a stream editor: it reads one line, runs your commands on it, prints
the result, and moves on. Every sed command has an optional address that says
which lines it applies to, and until now the address was implicit (all lines).
With `/regex/` in front, the command runs only when the line matches, and `d`
deletes what matches, so the line is never printed.

That makes `sed '/pattern/d'` the basic "remove these lines" tool, and it is the
twin of `grep -v`. Why choose sed? Because it can do more per pass (several
rules with `-e`, substitutions on the same pass) and because its exit status
does not complain when nothing is left, which matters under `set -e`.

Under the hood sed keeps just one line in a "pattern space", so it works on
files much larger than memory, and it never changes the input file: the
output goes to standard output. Cleaning up configuration files, zone files
and exports by deleting comments and blank lines is such a common step that
many people have this exact command in their shell history.

Going further: patterns select single lines. The next level selects whole
blocks by giving sed a start pattern and an end pattern.
