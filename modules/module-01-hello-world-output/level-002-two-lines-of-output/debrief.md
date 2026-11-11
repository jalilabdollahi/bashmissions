# Debrief: Two Lines of Output

A script is a sequence. Bash reads one line, runs it, finishes it, and only then reads the next. There is no "all at once", so the order of your commands is the order of your output.

## How it works
Each `echo` writes its text to standard output followed by a newline character. Two echoes in a row put two newlines in the stream, which your terminal shows as two lines. Nothing is shared between the commands: the second echo does not know the first one ran.

## In real work
Deployment scripts announce their progress this way: "Stopping service", "Copying files", "Starting service". When something fails, those ordered messages tell you exactly how far the script got. Reordering the lines of a script changes what it does, not only what it says.

## Going further
Echo is happy with any text, but spaces and special characters can surprise you. Level 3 shows why quotes matter.
