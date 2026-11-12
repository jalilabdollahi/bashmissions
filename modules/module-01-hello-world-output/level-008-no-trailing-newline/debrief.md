# Debrief: No Trailing Newline

A newline is not magic. It is just one more character, and `echo` adds it for you as a courtesy. Once you know that, taking it away is easy.

## How it works
Terminals move to the next line only when they receive a newline character. Without it the cursor stays right after the last character you printed, and whatever comes next continues there. `echo -n` omits the newline. `printf` never adds one, so a format without `\n` behaves the same way.

The trailing space in the label is part of the text. It is invisible, but it separates the label from what follows.

## In real work
This is how progress messages ("Copying files... done"), prompts ("Continue? ") and spinners are made. Remember also that the missing newline shows up in files: a file written without a final newline looks fine until another tool reads it.

## Going further
The next level separates what a script reports from what it complains about by using the other output stream, stderr.
