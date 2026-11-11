# Debrief: Library or Program?

Any bash file can be used two ways: *executed* (a new process runs it) or *sourced*
(`source file` or `. file` reads it into the current shell, as if you had typed the
lines yourself). A file written only as a program is hostile to sourcing: its last line
runs, its `set -e` sticks, and an `exit` inside it closes the caller's terminal.

Bash gives you two facts. `$0` is the name of the thing being run, and
`${BASH_SOURCE[0]}` is the name of the file whose lines are being read right now. Run
directly they are the same, sourced they differ. That one comparison lets a file define
functions on the way in and run its `main` only when it is the program, which is exactly
Python's `if __name__ == "__main__"`.

What this unlocks is **testability** and reuse. A test script can source your tool,
call `slugify` with nasty input, and compare the result without spawning the whole
program; other scripts can share your functions without copy and paste. The two rules
for a good library: top-level code only defines things, and shell options are left
alone, which is why strict mode moved into the program branch.

Going further: a reusable file should also say what it needs. Level 288 teaches how a
script checks that the bash running it is new enough.
