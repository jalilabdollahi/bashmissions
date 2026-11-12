# Debrief: Reorder Columns

The mental model: **names are stable, positions are not.** A column number is an
accident of how the export was built; a column name is a promise. Scripts that
say "column 3" break silently the day someone adds a field, and the breakage
shows up as wrong data rather than as an error. A script that reads the header
first and works through names fails loudly (an unknown column) or not at all.

Technically this is a two-phase pass inside one awk program: phase one fills a
lookup table from line 1, phase two applies it to every line. Associative arrays
make the table trivial, and `$(expr)` is the awk feature that makes the table
useful: field references are computed, not fixed. Setting `OFS` and building
the output in one variable keeps the separators right, including when a column
is requested twice.

Notice also the order of operations: the error is raised before any row is
printed. A projection that prints half of a file and then fails leaves a
downstream consumer with a truncated, valid-looking CSV, which is worse than no
output.

Real exports from CRMs, billing systems and analytics tools change their
columns all the time. Header-driven selection is the habit that keeps those
integrations alive.

Going further: projection moves data around but does no arithmetic. The next
level reads a numeric column and reports its count, sum, minimum, maximum and
average.
