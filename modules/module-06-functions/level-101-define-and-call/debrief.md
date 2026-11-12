# Debrief: Define and Call

A function is a named block of commands. Defining it does not run anything; it
only stores the body under that name. Calling it, by writing the name as if it
were a command, runs the stored body at that moment.

Under the hood Bash keeps a table of function names in memory for the life of
the shell. When it sees a word at the start of a command, it looks in that table
first, then at built-ins, then at programs on your PATH. That is why a function
named `rule` would hide a program also called `rule`, and why the definition must
be read before the call: the table is filled while the script is read.

You already know the payoff from the story. One definition means one place to
fix. Change the ruler width once and every section follows. Scripts with
functions are also easier to read because the main part reads like a summary:
`rule`, title, `rule`, status, `rule`.

In real work you will see functions used for log lines, usage messages and the
setup steps that every script repeats.

Going further: this ruler is always the same. The next level makes a function
that takes input so one definition can print different things.
