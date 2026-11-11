# Debrief: Iterate Keys in Order

A map gives you fast lookups but no order. Whenever the order matters you decide it, by sorting the keys and then looking each one up.

## How it works
`"${!map[@]}"` returns the keys in the map's internal order, which depends on a hash function and can differ between Bash versions. Nothing about insertion order or alphabet is promised. The reliable pattern is: extract keys, sort them with a tool that implements the order you want, loop over that sorted list and read `${map[$key]}` inside.

The choice of sort is part of the design. As text, "10" comes before "2" because the character `1` is smaller than `2`; `sort -n` compares numbers, so 2 comes first. `-r` flips either. For columns in a table, `sort -k` can sort by a field instead of the whole line.

The other new tool is splitting `key=value` with parameter expansion. `%%=*` and `#*=` cut at the first equals sign, so values may safely contain more of them. This is the standard recipe for parsing `KEY=VALUE` lines.

## In real work
Sorted reports from tallies, rack and port layouts, configuration dumps in a stable order that diffs cleanly.

## Going further
Next you will meet a map question that `${map[k]:-default}` cannot answer: "was this key set at all, even to nothing?".
