# Debrief: Functions Inside Loops

Loops repeat; functions name. Together they are the basic unit of readable
scripts: the loop says *what to go through*, the function says *what to do with
each one*. Compare reading `print_row "$host" "$pct"` with reading eleven lines of
conditionals and a printf in the middle of a `while`.

Notice what the function hides. If Gus later asks for the thresholds to move to
80 and 95, you change one function and nothing else. If he wants a second report
with the same row layout, you call the function from a second loop.

Technical points. A function called from a loop runs in the current shell, so it
can read and change the loop's variables (and that is why `local` matters, as the
global leak level showed). A `while read` loop fed by redirection or stdin keeps
variables like `rows`; the same loop at the end of a pipe (`cat f | while ...`)
runs in a subshell and loses them. Also, `read -r` is the safe default: it keeps
backslashes as they are.

Real examples: `check_site "$url"` for each line of a list, `archive_dir "$d"` for
each customer, `print_row` for each record.

Going further: what happens when two definitions have the same name? The next
level uses that on purpose.
