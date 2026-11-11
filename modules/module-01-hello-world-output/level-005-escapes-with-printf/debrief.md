# Debrief: Escapes with printf

`echo` is a convenience. `printf` is a precision tool. It prints exactly the characters you describe, nothing more, which makes the end of each line your responsibility.

## How it works
The text you give `printf` is a format. Most characters are copied over, but a backslash starts an escape sequence that printf translates: `\n` becomes the new-line character, `\t` becomes the tab character. These are real characters in the output, invisible in the terminal but very much there when a spreadsheet or another program reads them.

Single quotes matter here: Bash must not interpret the backslashes before printf sees them.

## In real work
Tab-separated output is the glue between scripts and spreadsheets or the `cut` command. Control over line breaks is also what lets you print a prompt without moving to the next line, which you will do in level 8.

## Going further
Next, printf's real superpower: placeholders that slot values into the text.
