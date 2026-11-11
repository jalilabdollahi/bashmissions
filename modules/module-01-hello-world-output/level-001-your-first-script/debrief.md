# Debrief: Your First Script

You just wrote a program. That is not an exaggeration: a script is a list of commands saved in a file so you do not have to type them again.

## How it works
When you start a script, the system looks at the very first line. If it begins with `#!` (the shebang), the rest of that line names the interpreter that should read the file. `#!/usr/bin/env bash` means "find bash wherever it is installed on this machine and use it". That is why the same script runs on a laptop and on a server.

`echo` is a command that writes its arguments to standard output, the stream your terminal shows on screen, and finishes with a newline.

## In real work
Almost every operations job starts as a handful of commands pasted into a file. Welcome banners, deployment steps and nightly clean-ups all begin like this.

## Going further
Next you will print more than one line and see that the order of your commands is the order of the output.
