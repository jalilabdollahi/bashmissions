# Debrief: Parse key=value Files

Configuration is the most common structured data a script reads, and
`key=value` is its most common format. Pure Bash can parse it with one idiom:
`while IFS='=' read -r key value; do ...; done < file`. Understanding why it
works is more valuable than memorising it.

`IFS` (the Internal Field Separator) tells `read` where to cut a line. Putting
the assignment in front of `read` applies it to that one command, so your
script's other word-splitting is unaffected. When the line has more pieces than
there are variables, the last variable swallows the rest, separators included.
That rule is why values containing `=` survive, and why `read -r a b` is a
common way to split "first word, then everything else".

Two traps explain the shape of the loop. `-r` prevents backslash processing,
which would corrupt Windows paths and regexes. And `read` returns failure at EOF
even when the final line, missing its newline, was successfully read, so a loop
that must see every line needs the `|| [[ -n $key ]]` clause.

For real-world configs there is a shortcut, `source file`, which runs the
file as Bash. It is convenient, and dangerous when the file is not yours: a line
like `x=$(rm -rf ~)` would run. Parsing it as data is safer.

Going further: you now have the building blocks for the whole module. The last
level combines filters, counting, sorting and formatting into one report.
