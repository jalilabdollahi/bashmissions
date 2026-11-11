# Debrief: Error Messages That Help

An error message is documentation that appears at the exact moment someone needs
it, usually someone in a hurry and often someone who did not write the script.
"bad config" forces them to open the source and reverse-engineer your checks.
Three questions turn it into help: *what* went wrong, *where* (file, line,
value), and *how to fix it*.

Specifics matter more than polish. Include the offending value, in quotes so
stray spaces show up. Use the `file:line:` shape that compilers and editors
understand. Offer a remedy that is a concrete command or an example, not "check
your configuration". Keep the first line short enough to survive in a log search,
and put the advice on a second, indented line.

The channel matters as much as the words. Errors go to stderr so that
`./check.sh > report.txt` does not smuggle a failure into the report, and so a
terminal user sees them even when stdout is redirected. Combine that with the
specific exit codes from earlier and both humans and programs are served.

Good messages also shape behaviour: a clear one gets fixed by the user in a minute,
a vague one becomes a support ticket. Noor's desk will notice the difference.

Going further: the last level follows an exit code through a stack of layers, a
function inside a pipeline inside a wrapper, so the right number arrives at the
top.
