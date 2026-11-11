# Debrief: Count a Character

This level is about **composing** two tools you already own. Replace-all can
delete, and length can measure; together they count. It is a nice example of how
Bash programmers think: with no ready-made operation, reshape the data until a
simple operation answers the question.

The key was the negated bracket `[^,]`. Brackets in a glob pattern match one
character from a set (`[abc]`, `[0-9]`, `[[:digit:]]`); a leading `^` (or `!`)
flips it to "any character not in the set". To count digits you would delete
`[^0-9]`; to count slashes in a path (its depth), `[^/]` (escape the slash
inside the expansion if you need to).

Why count commas at all? Because structure checks are cheap and powerful. Before
parsing a row, verifying the number of delimiters catches broken exports early:
CSV rows, `host:port` pairs, colon-separated passwd lines, dotted version numbers.
Be aware of the limit: this counts every comma, including ones inside quoted CSV
fields. Real CSV with quotes needs a proper parser, a good reason to choose
the export format carefully.

The loop and the line counter are the same shape as the previous level; the new
idea is the transformation, not the plumbing.

Going further: now you can take strings apart, count them, and search them.
The next level builds a new string by walking over characters one at a time.
