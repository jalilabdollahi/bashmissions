# Debrief: The Script Knows Its Name

Inside a script, the command line that launched it is available as numbered variables. Number zero is special: it is the command itself.

## How it works
When you type `./tools/backup.sh`, Bash sets `$0` to `./tools/backup.sh`, folders included. When you type `bash backup.sh`, it is `backup.sh`. Because the value depends on how someone started the script, scripts that print their name usually run it through `basename` first, which removes everything up to the last slash.

`basename` is an ordinary program with no knowledge of files: it just edits the text of a path. It never checks that the file exists, so it works on any string.

## In real work
Usage messages ("usage: backup.sh DIR"), log lines and temporary file names all use `$0`. Printing the real name means help texts stay correct after someone renames the script.

## Going further
Next: how to print a long block of text, such as a letter to a customer, without a pile of echo lines.
