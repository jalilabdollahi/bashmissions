# Debrief: A Boxed Banner

Repeating text is a pattern, not a typing task. Printf's rule of re-running its format for leftover arguments turns a one-character format into a line of any length.

## How it works
Brace expansion is Bash's job, done before the command runs: `{1..30}` becomes `1 2 3 ... 30`, thirty separate arguments. Printf then sees the format `=%.0s` and thirty values. Each round prints a literal `=` followed by zero characters of the current value. After thirty rounds you have thirty equals signs, and the numbers have never appeared.

Widths make the middle row match the border: 2 characters for `| `, 26 for the field, 2 for ` |` adds up to 30.

## In real work
Separators in reports, underlines for titles, progress bars: all built by repetition. Changing the width of a banner then means changing one number.

## Going further
You now have all the pieces of formatted output: placeholders, widths, escapes, colours and streams. The last level of this module asks you to combine them.
