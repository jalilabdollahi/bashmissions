# Debrief: Count Lines and Words

## What you learned

Counting is easy; making the *output* predictable is the skill. `wc` has
three behaviours to remember: with a file argument it prints the name; with
`<` it prints only the number; and the padding of that number depends on
the platform. Arithmetic expansion `$(( ))` is the cheap, portable way to
get a clean integer.

## Under the hood

`wc -l` does not count "lines" in the human sense; it counts newline
characters. A last line without a trailing newline is therefore missed by
`-l`, which surprises people with files made by tools that omit it. `-w`
counts runs of non-blank characters, so extra spaces and blank lines do not
change the answer.

BSD and GNU `wc` agree on counts but not on layout. Scripts that compare
the output to a literal (`[[ $(wc -l < f) == 3 ]]`) break on macOS unless
the value is normalised first.

## In real work

Line counts drive "is this log empty?" checks, "how many rows did the
export produce?" sanity tests, and quick size reports like Gus's. The
normalised-integer habit applies to any command whose output you compare.

## Going further

You can now read, pick from, and measure a file. Time to move files
around: next, copying with a safety net.
