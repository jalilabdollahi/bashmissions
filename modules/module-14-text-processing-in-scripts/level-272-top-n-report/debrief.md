# Debrief: Top-N Report

You have now built a complete report from nothing but standard tools, and the
shape of the solution is the lesson. Each stage reads lines and writes lines,
knows nothing about the others, and can be run alone to see what it does. When
the output is wrong, you cut the pipeline at the stage before and look. This is
how experienced people write shell: add one stage, run it, add the next.

The pipeline also shows the division of labour in the module. `awk` selects and
formats, because it understands fields. `sort | uniq -c` counts, because sorted
data makes counting trivial. A second `sort` ranks, `head` truncates, and `sed`
smooths a portability difference. Replace awk's filter with `grep` and the
report works on another log; swap the field number and it reports clients rather
than names.

Two professional habits are in the details. Ties are broken explicitly, so the
output is reproducible instead of depending on how the sort happened to behave.
And the edge cases (fewer lines than N, no matching lines) fall out of how the
tools behave rather than needing special code.

Going further: the next module is about how to package scripts like this so that
other people can use them: headers, usage messages, functions and a proper
structure.
