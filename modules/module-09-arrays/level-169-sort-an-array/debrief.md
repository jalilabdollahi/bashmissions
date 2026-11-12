# Debrief: Sort an Array

To sort an array, take it to a tool that sorts lines and fetch the result back. That is a round trip: array, then lines, then `sort`, then array.

## How it works
`printf '%s\n' "${arr[@]}"` is the bridge out. The format string is applied once per element, so each element becomes exactly one line. Because you quote the expansion, elements with spaces stay whole. `mapfile -t x < <(...)` is the bridge back, with the newline stripped from each line.

The order itself comes from `sort`, and the locale decides what "alphabetical" means. Under `LC_ALL=C` the comparison is by byte value, so capital letters come before lowercase ones. On a desktop with an English locale it may differ, which is why scripts that need a stable order set `LC_ALL=C` explicitly. Numeric order needs `-n`: as text "443" comes before "80" because `4` is smaller than `8`.

The empty array is the trap. `printf '%s\n'` with zero arguments still runs its format once, producing one empty line. That empty line would come back as a one-element array. Always guard the empty case before the round trip.

## In real work
Reports with stable order, "top five" lists, comparing two sets of hosts with `comm` (which requires sorted input).

## Going further
Sorting groups equal items next to each other. Next you will remove duplicates, but with the original order preserved, which `sort -u` cannot do.
