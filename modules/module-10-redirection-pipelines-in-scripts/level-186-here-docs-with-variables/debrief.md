# Debrief: Here-Docs with Variables

## What you learned

A here-document is a file that lives inside your script. `<<WORD` takes the
lines up to the closing WORD and feeds them to a command's standard input.
With an unquoted WORD it is a template: variables and command substitutions
are filled in first.

## Under the hood

The shell reads the body, performs parameter expansion, command substitution
and arithmetic expansion on it (the same set as inside double quotes, except
that quote characters are left alone), and gives the result to the command,
typically through a temporary file or a pipe. The command sees plain text on
stdin and has no idea a template was involved.

If you indent the body, the indent is part of the text, unless you use
`<<-` with leading tabs (not spaces), which strips them.

## In real work

Email bodies, generated config files, SQL snippets, help messages in a
`usage()` function. Any time several lines of text contain a few variable
parts.

## Going further

Sometimes the text must stay exactly as typed, `$` signs and all, for
instance when you generate another script. The next level shows how to turn
expansion off.
