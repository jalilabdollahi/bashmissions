# Debrief: Quotes Keep Your Spaces

Bash does not hand your raw text to a command. It first splits the line into words, and only then runs the command with those words as its arguments. Spaces are separators, and any number of them counts as one.

## How it works
Quotes change the splitting rule. Everything inside a pair of double quotes becomes a single argument, no matter how many spaces it contains. The quote marks themselves are consumed by Bash and are not part of the text echo prints.

This is why `echo "a    b"` shows four spaces while `echo a    b` shows one. In the first case echo received one argument, in the second it received two.

## In real work
Quoting is the number one source of mysterious bugs in scripts: file names with spaces, customer names such as "Harbour Bakery", messages with gaps. Get in the habit of quoting text that should stay together.

## Going further
Double quotes still let Bash peek inside the text and replace things like dollar signs. The next level shows how to switch that off.
