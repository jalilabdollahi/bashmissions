# Debrief: Read Two Files at Once

## What you learned

Input works like output: you can open files for reading on numbers of your
choice and read from any of them. `exec N< file` opens, `read -u N` takes one
line, `exec N<&-` closes. Two files can be consumed in lockstep.

## Under the hood

An open file remembers its read position. Each `read` takes bytes up to the
next newline and leaves the position after it, so the next call, on the same
descriptor, continues from there. That is why two separate `while read` loops
over the same file would each start at the top, but successive `read -u 3`
calls move forward.

Standard input is just descriptor 0. A loop `done < "$1"` rewires 0 only for
the loop; descriptor 3 is unaffected. When `read` hits end of file it
returns 1, which the `|| address="(none)"` fallback catches.

## In real work

Merging two exports, matching a list of names to a list of values, comparing
two sorted files line by line, or reading a config from one file and answers
from another.

## Going further

So far you have opened descriptors. Next, a trick with the standard ones:
temporarily pointing stdout somewhere else and then restoring it.
