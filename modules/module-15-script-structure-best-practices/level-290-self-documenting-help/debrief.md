# Debrief: Self-Documenting Help

Documentation that lives in two places will disagree within a month. The fix is to
keep one copy and *derive* the other. A script can read its own source, because a
script is a file and `$0` is its path, so the header comment can serve both readers:
humans who open the file, and users who type `--help`.

The extraction is small stream processing, the same awk/sed skills as the text-tools
module applied to yourself: skip the shebang, strip the comment marker, stop at the first
non-comment line. Details matter. A lone `#` must still produce a blank line so that
paragraphs survive. The scan must stop at the first non-comment line, or it would print
code. And `$0` changes meaning when a file is sourced (then `${BASH_SOURCE[0]}` is the
right name, as level 287 showed), so a tool meant for both uses should prefer that.

You will see the idea in many mature scripts: a `usage` extracted from `#?` markers, or
a `help` that greps for `## ` comments. It is also the sign of a script ready to be
handed on: it has a header, a usage function, constants, a `main`, safe quoting and
a guarded entry point. That is everything this module set out to teach: scripts that
outlive their authors.

Going further: when a script grows past one screen, the next questions are about
finding bugs in it. The Debugging module turns scripts into things that explain
themselves while they run.
