# Debrief: Side by Side

Most tools so far work down a file. `paste` works across files: it turns
several one-column files into a table, matching rows by position. Think of it
as the horizontal counterpart of `cat`, and as the inverse of `cut`: `cut`
splits a table into columns, `paste` assembles columns back into a table.

The dependence on position is the whole contract. Line 7 of one file goes
with line 7 of the others, whatever they contain. That is perfect when the
files were produced together (three exports taken at once, a list of names and
a list of results from a `for` loop) and dangerous when they were not,
because a single missing line shifts everything after it. When rows must be
matched by what they say rather than where they sit, you need a join by key,
which comes next.

A last tip: `paste -sd, file` joins all the lines of one file into one
comma-separated line, a handy way to build a `--hosts=a,b,c` argument from a
list. And `-` stands for standard input, so you can mix files and pipes.

Going further: matching by key, not by position, is what `join` does. It has
one big precondition, which the next level makes you face.
