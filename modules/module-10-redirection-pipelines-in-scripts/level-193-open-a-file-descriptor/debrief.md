# Debrief: Open a File Descriptor

## What you learned

File descriptors are numbered slots in the process's table of open files.
You are free to use 3 to 9 for your own files. `exec N> file` opens one for
the whole script, `>&N` writes to it, and `exec N>&-` closes it.

## Under the hood

A plain `cmd > file` opens the file, installs it as descriptor 1 for that
single command, and closes it afterwards. `exec` without a command applies the
redirection to the shell itself, permanently, so the slot stays populated until
you close it or the script exits. Child processes inherit the open slot too,
which is how background tools can write to your report.

Since the file is opened one time, the position advances naturally with each
write. No truncation happens in the middle, so you do not need `>>`.

## In real work

Reports and audit logs written from several functions, lock files held open
for the lifetime of a script, and separating "user messages" from "machine
output". Tools like `flock` also rely on a held descriptor.

## Going further

You opened a descriptor for writing. The next level opens one for reading,
and consumes two files in lockstep.
