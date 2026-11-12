# Debrief: HTML Report

The mental model: **data and markup must never be mixed raw.** The moment text
from outside is inserted into a page, the page's language (HTML) and the data's
language (anything a human typed) share one string, and any character that is
special in HTML can change the structure. That is the whole idea behind
cross-site scripting: not a clever exploit, just text that was allowed to be
code. The defence is boring and universal: escape on the way out, in the
language of the destination. For HTML text that means `&`, `<` and `>`.

Order matters because escaping adds characters. `&` goes first; otherwise the
`&` in `&lt;` is escaped a second time and the visitor sees a literal
`&lt;`. The same shape appears everywhere: escape the escape character first.
You met the CSV and JSON versions of this in earlier levels.

The here-document is the shell's template engine. The text is written the way
it will look, the variables fill the blanks, and since expansion happens once,
text *inside* a variable is not interpreted as shell code. That is the same
"data is not code" rule, applied to Bash itself. (If the delimiter is quoted,
`<<'EOF'`, nothing is expanded at all.)

A tiny shell quirk: Bash 5.2 changed the meaning of `&` in the replacement
side of `${v//a/b}`. Knowing why `shopt -u patsub_replacement` appears in
scripts saves an hour of debugging.

Going further: reports describe one dataset. The next level compares two
versions of a dataset and lists what was added, removed and changed.
