# Debrief: Find by Type and Size

## What you learned

`find` tests are filters you chain: type, then size, then name, and so on,
all of which must hold. `-type` separates files from folders (and links and
other things), and `-size` with the `c` suffix compares exact byte counts.

## Under the hood

Each entry the tree walk visits is checked against the tests from left to
right; the first false one stops evaluation for that entry (that is also why
cheap tests such as `-type` come first). `-size` with a plain number counts
512-byte blocks and *rounds up*: a 1-byte file counts as one block, so `-size 1`
matches it and `-size 0` matches only empty files. With `c`, there is no
rounding at all.

Many Linux-only tutorials use `-size +10M`. macOS understands `M` too, but
the rounding rules differ in corner cases, so byte counts are safer for scripts.

The starting folder is part of the walk. That is why counting folders with
`-type d` needs the "minus one".

## In real work

"What is eating the disk?" scripts, cleaners for crashed-upload leftovers
(zero-byte files), and audits for oversized attachments all follow this
pattern.

## Going further

Size is one property; age is another. Next: `find -mtime` and `-newer`.
