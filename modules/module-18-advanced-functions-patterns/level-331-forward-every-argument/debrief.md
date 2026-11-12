# Debrief: Forward Every Argument

`"$@"` is the shell's way of saying "the argument list, exactly". Unlike
nearly every other expansion it produces *several* words from one
parameter, each kept intact. That makes it the foundation of every wrapper:
decorators, retry loops, timing and audit functions, all of the coming
levels, are this one idea plus a little extra.

## Under the hood

Bash stores arguments as a list, not a string. Quoting `"$@"` tells the
parser "expand to the list's elements, each as a separate quoted word".
Without quotes, the elements are rejoined into text and then subjected to word
splitting (spaces become boundaries) and filename expansion (`*` becomes the
current folder's contents), after which you cannot recover the original.
`"$*"` goes the other way: one string, joined by the first character of
`IFS`.

Edge cases decide quality. An empty argument must stay empty, and zero
arguments must stay zero. `"$1"` forwards one word even when there is none;
`"$@"` forwards exactly what exists.

## In real work

`sudo`, `time`, `nice` and `env` are all wrappers of this kind, and every
shell function that adds `--verbose` or a prefix to another command should
end in `"$@"`. A reviewer's first search in a wrapper script is for an unquoted
`$@` or a stray `$*`.

## Going further

Not every function has its state ready: sometimes it must remember something
between calls, like "the last number I handed out". That is next: generators.
