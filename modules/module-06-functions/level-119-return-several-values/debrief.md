# Debrief: Return Several Values

Shell functions return one status number and one stream of text. To return
several values you pack them into the text and unpack them in the caller. The
pattern is `printf` on one side and `read` on the other, with whitespace as the
separator.

That works because `read -r a b c` assigns word 1 to `a`, word 2 to `b`, and *all
the remaining words* to the last variable. So if the last value may contain
spaces, put it last. If a value itself may contain spaces, choose a different
separator (`IFS=, read -r ...`) or use name references.

Compare the options you now know for getting data out of a function:

- exit status via `return`: a small number; best for yes/no;
- stdout via `$( )`: one value, or several packed on a line;
- name references: any number of variables, set directly in the caller;
- globals: easy, but exactly the leak from level 107.

Choose the plainest one that works. Stdout is the Unix way and keeps functions
composable; references are for structured results.

A common real example is `read -r user host <<< "${address//@/ }"` to split
`user@host`, or a function returning `status elapsed` for a health check.

Going further: the final level combines everything: arguments, status codes, die,
log and captured results in one realistic script.
