# Debrief: Validate CSV Schema

The mental model: **a file format is a contract, and a script that consumes it
should check the contract first.** CSV has no enforcement of its own. Any tool
can write a row with an extra comma, and the damage appears far from the cause:
columns shift, totals are wrong, and the bug report names the wrong system.
A validator turns that silent drift into a loud, local message with a line
number.

Two awk ideas carry the level. `NF` is recomputed for every record, so
`NF != 4` is the whole schema check for shape. `NR` counts physical lines, so
messages stay accurate even when blank lines are skipped. The order of checks
matters too: test the field count before looking at any column, because on a
misshapen row `$3` is not the priority any more.

Notice the two audiences of the output. People read the `line N: ...` messages;
programs read the exit status. Because awk's own status becomes the script's
status, `./solution.sh export.csv && ./process.sh export.csv` is a safe
pipeline: processing never starts on bad data. Real systems do this at the
boundary: upload handlers, ETL jobs and CI checks all start with a validator
like this one.

Going further: once you know the file is well formed, the next level uses
the same column numbers to pick only the rows you care about, by comparing
columns with conditions.
