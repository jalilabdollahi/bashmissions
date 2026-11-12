# Debrief: First Argument

Your script stopped being a fixed recipe and became a tool: the same file now
produces a different result for every caller. The mental model is that the shell
cuts the command line into words, puts the command first, and passes the rest
to the script as numbered variables: `$1`, `$2`, `$3`...

Under the hood the shell does the word splitting before your script starts. That
is why quotes belong to the caller: `"Tidewater Books"` arrives as one word,
while `Tidewater Books` arrives as two. Your script cannot tell the difference
afterwards, it only sees `$1`.

In real work almost every admin script begins by reading its arguments: a
hostname to check, a customer to look up, a file to process. Arguments are the
simplest user interface there is, no menus and no prompts, which also makes
scripts easy to call from other scripts, cron and CI.

Going further: what happens when the caller passes two names, or none? The next
levels cover several arguments, counting them with `$#`, and later complaining
politely when one is missing.
