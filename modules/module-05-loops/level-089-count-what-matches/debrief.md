# Debrief: Count What Matches

Counting inside a loop is a pattern with three parts: initialise, test, increment. Once you recognise it, you will find it in half of all scripts.

## How it works
Counters are ordinary variables that live outside the loop, so they keep their values from round to round. Starting them at zero is not decoration: an unset variable is an empty string, and while arithmetic tolerates that, printing it gives an empty report instead of `0`.

The test decides who gets counted, and it can be anything from the previous module: a glob match like `5*`, a numeric comparison, a file test. Counting with a test is how you express "how many X are there?".

`read -r client status path` shows how field splitting works. Fields are separated by whitespace, and the last variable collects the remainder of the line. If a line has fewer fields than variables, the extra variables are simply empty.

The summary line goes after `done`, because the loop must finish before the totals mean anything.

## In real work
Error rates, failed logins per day, number of servers over 90% disk, number of customers without an invoice. Counting is the first step of almost every report.

## Going further
Two loops can work together, one inside the other. Level 90 builds grids and combinations with nested loops.
