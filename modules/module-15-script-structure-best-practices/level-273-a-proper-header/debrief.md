# Debrief: A Proper Header

A header is the contract at the top of a script. Line 1 says who runs the file,
line 2 says why it exists, and the strict-mode line says how the script behaves when
things go wrong. Together they turn a file that "works on my machine" into one that
a stranger can trust at 3 a.m.

Under the hood: the kernel reads the `#!` line and starts that program with your
script as its argument. `env` is itself a program that searches `PATH` for `bash`,
so one script works on Debian, on a Mac with Homebrew and in a container.
`set -e` makes the shell exit when a simple command fails, `set -u` turns the
expansion of an unset variable into an error, and `pipefail` changes a pipeline's
status from "the last command's" to "the first failure's". Three small switches
close three big holes: carrying on after errors, silent typos, and failures hidden
inside pipes.

You will meet this exact block at the top of nearly every serious shell script on
GitHub. It is not a cure-all: `set -e` has surprising exceptions (Module 11) and
some commands legitimately fail. The skill is to start strict and loosen on purpose.

Going further: a header tells people what the script is. The next level adds the
other half: a way for the script to tell people how to use it.
