# Debrief: Comments Are for Humans

A script is read far more often than it is written. Comments are how you talk to the next reader, who is often you in three months.

## How it works
When Bash reads a line, anything from an unquoted `#` to the end of the line is dropped before execution. The shebang is the one exception: it is a comment as far as Bash is concerned, but the operating system reads it before Bash even starts, which is why it must be the very first line.

A comment can sit on its own line or at the end of a command. Inside quotes the `#` is just a character, so `echo "#1 server"` prints the hash.

## In real work
Good comments say why, not what. `# retry because the API is flaky on Mondays` helps; `# print the name` does not. Headers that state purpose and owner turn a mystery file into something a stranger can trust.

## Going further
The next level gives a script a voice that machines understand: the exit code.
