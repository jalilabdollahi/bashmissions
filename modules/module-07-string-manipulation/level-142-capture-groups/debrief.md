# Debrief: Capture Groups

Matching answers "does it fit?". Capturing answers "what were the parts?". Put
parentheses around the pieces you care about and Bash keeps the matched text in
`BASH_REMATCH`: element 0 is the whole match, and elements 1, 2, 3... are the
groups, numbered by the order of their opening parenthesis. It is a regular array,
exactly like the one `read -a` made earlier, just filled by the match.

A few rules that save time. The array is overwritten by every `=~`, so copy
what you need before running another match. If the match fails, do not read the
array: it can hold stale values from the last success, which is why every use sits
inside the `if`. And the best regexes are *narrow where it matters*: `[^ ]+` for
"anything but a space" and `[0-9]{3}` for "exactly three digits" make the match
precise without describing the parts you do not need.

This closes the module. You started by measuring a string, learned to cut by
position and by pattern, to replace, to change case, to split and join, to test
and count, and finally to take a line of free-form text apart with a regex.
Together these are the string tools of day-to-day shell scripting, and all of
them run inside Bash, without spawning a single extra process.

Going further: the next module is arithmetic. Strings are text; now we make the
numbers inside them count.
