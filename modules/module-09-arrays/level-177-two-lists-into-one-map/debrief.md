# Debrief: Two Lists into One Map

Two arrays with the same length and a shared index are really one table in disguise. Zipping them into a map makes that table explicit: now you can ask for the address of a host instead of the address at position 3.

## How it works
The index is the glue. Elements with the same number belong together, so one loop variable indexes both arrays: `keys[i]` and `values[i]`. Turning that into a map is a single assignment, `map[${keys[i]}]=${values[i]}`, executed for every `i`.

The length check is the safeguard that makes the glue trustworthy. If the lists have different lengths, something went missing somewhere, and zipping anyway would create a plausible-looking but wrong table. Failing loudly is the professional behaviour: exit non-zero, say what you found, write it on stderr.

The sorting detail teaches a general rule: sort the data in the form the order is defined on. The order is by host name, so sort the host names. Sorting `host=ip` lines compares the equals sign and the address along the way, and a name that is a prefix of another name ends up in the wrong place.

Duplicate keys collapse silently, by design. If duplicates indicate an error in your data, detect them with `-v` before assigning.

## In real work
Headers and rows of a CSV, names and values from two tools, parallel `--name`/`--value` flags, any "two columns arriving separately" situation.

## Going further
The last level goes two-dimensional: a grid stored in a single map with keys like `$row,$col`.
