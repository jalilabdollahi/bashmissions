# Debrief: Quote to Stop Injection

A shell script is a tiny text-rewriting machine. Before a command runs, the
shell rewrites its line: it substitutes variables, then cuts the results into
words, then replaces patterns with file names. Quotes are how you tell it which
rewrites to skip. The attacker's mental model is simple: *anything I can type
that reaches an unquoted expansion gets re-read as shell syntax*, so they try
spaces (extra arguments), stars (other files), leading dashes (extra options),
and, wherever a second shell is involved, `;` and `$(...)`.

The defence is boring and total: double-quote every expansion that holds data,
and put variable text in the *argument* position, never in the command
position. The path `"tickets/$customer.txt"` is quoted as one unit, so the
fixed parts and the variable part travel together.

You will see this rule enforced by linters such as ShellCheck (warning SC2086),
and in code review everywhere a script handles file names, customer names or
anything that arrived from a web form, a ticket or an email.

Quoting stops the shell from misreading your data. It does not make the data
*safe to use*: a name may still be something you should refuse. That is the next
step.

Going further: levels 356 and 357 deal with the two ways data still becomes code
(`eval`) and with deciding which values deserve to be accepted at all.
