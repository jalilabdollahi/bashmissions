# Walkthrough: Write to a File

## The plan

`tide-report` prints three lines. Instead of letting them reach the terminal,
we reconnect the command's standard output to a file. The shell does this
before the program starts, so the tool itself needs no changes: it still
believes it is "printing".

## Step by step

First, read the argument into a readable name:

```bash
host=$1
```

Then run the command and put `> report.txt` after it:

```bash
tide-report "$host" > report.txt
```

When the shell sees `> report.txt` it opens the file for writing. If the file
did not exist it is created; if it did exist it is truncated to zero bytes
first. That is exactly the "replace the old report" behaviour the objective
asks for.

## The complete solution

```bash
#!/usr/bin/env bash
host=$1
tide-report "$host" > report.txt
```

## Trying it by hand

```bash
./solution.sh anchovy
cat report.txt          # host=anchovy ...
./solution.sh barracuda
cat report.txt          # only barracuda now
```

Notice that the terminal stays silent while the script runs: the three lines
went to the file.

## An alternative

You could run the tool normally and copy its output with `tee`, but then it
would also appear on screen, and you would be doing more work than needed.
Plain `>` says exactly what you mean: "this output belongs in that file".
