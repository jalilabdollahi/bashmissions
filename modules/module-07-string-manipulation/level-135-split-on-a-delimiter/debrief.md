# Debrief: Split on a Delimiter

`IFS` is the *internal field separator*: the set of characters Bash treats as
the gaps between words when it splits text. By default it is space, tab and
newline. Setting it to `:` for the duration of one `read` turns that command into
a colon-splitter. The form `IFS=x command` changes the variable only for that
command's lifetime, so nothing leaks into the rest of your script.

`read -a` completes the idea: instead of one variable per field, you get an
array whose elements you reach by number. Arrays get a whole module of their own
later, so for now remember three things: the index starts at 0, `${arr[i]}` reads
element `i`, and `${#arr[@]}` is how many elements there are.

Two details make this robust. Empty fields are kept when the delimiter is not
whitespace: `a::b` gives three elements, the middle one empty, so positions stay
reliable. And only the delimiter splits: spaces inside a field (the user's full
name, a home directory with a space) are preserved because we set IFS to the
colon alone.

Real life: `/etc/passwd`, `PATH` (colon list), CSV-like exports, `host:port`,
version numbers split at dots, timestamps split at colons.

Going further: after taking something apart, you will want to put it back
together with a different separator. That is next.
