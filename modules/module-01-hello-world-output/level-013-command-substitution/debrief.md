# Debrief: Command Substitution

Until now your text came from you. With `$( ... )` the text can come from anywhere a command can reach: a file, the clock, a counter, another script.

## How it works
Bash scans the line for `$( ... )`, runs the command inside in a subshell, collects its standard output, strips the trailing newlines, and swaps that text into the line. Only after that does the outer command, here `echo`, run. So `echo` never knows a substitution happened: it just receives a longer string.

The inner command gets the same current folder as the script, which is why a relative path like `fixtures/queue.txt` works inside it.

## In real work
Timestamps in file names, counts in reports, the first line of a config: nearly every useful script builds values this way. Keep the substitution inside double quotes when the output may contain spaces.

## Going further
Next, a different question a script can ask: what is my own name, and what is the file part of a path?
