# Debrief: Input from a File

## What you learned

Descriptor 0 is standard input, the stream a program reads from. `<` replaces
it with a file, so any command that reads stdin can be fed from a file without
changing the program.

## Under the hood

The shell opens the file read-only and installs it as slot 0 before the
command starts. The command calls `read()` on descriptor 0 and gets the file's
bytes; at the end of the file it receives end-of-file, the same signal the
terminal gives when you press Ctrl-D. This is why one program works equally
with keyboard, file and pipe input: it only ever sees slot 0.

If the file cannot be opened, the shell reports the error and never starts the
command. That is why checking beforehand lets you give a friendlier message.

## In real work

Feeding SQL scripts into `mysql < dump.sql`, config files into parsers, and
list files into `while read` loops (`done < list.txt`). That last form is one
of the most common loops in shell scripting.

## Going further

A file is not the only thing you can feed. Next: writing the input text
inside the script itself, with here-documents.
