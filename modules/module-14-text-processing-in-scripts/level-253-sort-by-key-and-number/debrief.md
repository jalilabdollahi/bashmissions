# Debrief: Sort by Key and Number

Real reports are rows with columns, and `sort` can treat each line as a record.
`-t` says what separates the fields, `-k` says which field (or range) to compare,
and flags such as `n` and `r` say how. Several keys form a priority list: the
first decides, the next only breaks ties. That is the same logic as a
spreadsheet's "sort by A, then by B".

Numeric comparison matters because text order is blind to magnitude. As text,
`95` is greater than `120`, because `9` beats `1`. With `n`, `sort` reads the
leading digits as a number first. Decimals work too.

The subtle part is the key range. `-k3` means "from field 3 to the end of the
line", which is almost never what you want; `-k3,3` limits it to the one
field. Without a tie-breaker, lines that compare equal may come out in a
different order on a different system, so a deterministic report names its
second key.

Going further: sorted data has a useful property: equal lines end up next to
each other. The next level uses exactly that to collapse repeats.
