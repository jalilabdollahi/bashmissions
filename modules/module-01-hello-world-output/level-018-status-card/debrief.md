# Debrief: Status Card

You have now seen the whole output toolkit of a Bash script: text, quoting, formatting, streams, comments, the environment, command substitution and exit codes. Real scripts are these pieces in a sensible order.

## How it works
Each part of the card writes to a different place or in a different way: the here-document and printf lines go to standard output, the log note to standard error, and the status number to the caller as the exit code. The three channels are independent. A pipe sees only the card, a log collector can capture only the note, and the monitoring tool reads only the number.

The values come from the environment, not from the code. That is why the same script works for every server.

## In real work
Wrapper scripts, health checks and report generators look exactly like this. When you read an unfamiliar script, ask three questions: what does it print, what does it complain about, and what status does it return.

## Going further
So far all the data arrived by environment variables or files. Module 2 starts with variables you create yourself, and from there on your scripts begin to make decisions.
