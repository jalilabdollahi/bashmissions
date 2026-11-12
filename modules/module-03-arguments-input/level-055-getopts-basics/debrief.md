# Debrief: getopts Basics

`getopts` is the standard Unix option parser, built into Bash and `sh`. Its
design is tiny: an *option string* lists letters, a trailing colon means "this one
takes a value", and a loop yields one letter at a time, with `$OPTARG` holding the
value when there is one. That is all of it, and it behaves the same as the tools
you use every day: `ls -la`, `tar -xzf archive`, `head -n 5`.

Under the hood `getopts` keeps its own position in the arguments in the variable
`OPTIND`, which is why it needs no `shift`. After the loop, `shift $((OPTIND - 1))`
removes the options and leaves the remaining *positional* arguments (file names,
hostnames) in `$1`, `$2`... For this level there were none, but real scripts
nearly always want that line.

A design habit: put defaults first, parse in the loop, validate afterwards, and
keep the work separate from the parsing. Your script then reads like its own
documentation.

Going further: right now a wrong option, say `-x`, makes `getopts` print its own
rather unfriendly message. The next level takes control of errors.
