# Debrief: Markdown Report

The mental model: **a report is a document with a skeleton, and the skeleton
depends on the data.** Reading data and writing a document are two phases. First
collect and decide (how many items, which ones, in what order). Only then print,
because the title may need a count, the table may be replaced by a note, and the
rows need sorting. Doing the printing in `END`, after the data is in hand,
makes the structure of the script match the structure of the output.

Markdown tables look informal but have rules: a header row, a separator row
whose colons set the alignment (`---:` is right-aligned, good for numbers), and
cells divided by `|`. Whenever you generate text in a format that has special
characters, you inherit an escaping job. Here it is the bar; in the next level
it will be three characters of HTML. The escape belongs at the point where
untrusted data enters the document, not scattered through the code.

The "nothing to report" branch deserves a line of its own. An empty table
renders as a header with nothing under it and looks like a bug. A sentence
that says nothing is wrong is information, and a report that always has the
same sections is easier to scan week after week.

Finally, validation again: bad rows are skipped *and reported*, and they are not
counted in M, so the summary line stays true.

Going further: the same data can be turned into a web page. The next level
generates HTML with a here-document template, where escaping `<`, `>` and `&`
is not cosmetic but a security matter.
