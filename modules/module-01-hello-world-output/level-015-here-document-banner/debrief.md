# Debrief: Here-Document Banner

When the output is a block of text rather than a single line, writing it as a block is clearer. That is what a here-document is for.

## How it works
The `<<EOF` after a command tells Bash: "the standard input of this command is the text on the following lines, up to a line that is exactly `EOF`". Bash collects that text, performs expansions on it (variables, `$( ... )`), and gives the result to the command's input. `cat` simply copies its input to its output.

The delimiter can be any word. `EOF` is traditional. It must stand alone on its line, with no leading spaces, or Bash keeps looking for it and complains at the end of the file.

## In real work
Config files, e-mails, SQL snippets, usage help: here-documents are the standard way to embed multi-line text in a script. The same block can feed `mail`, `tee` or a file.

## Going further
Later you will learn how quoting the delimiter, `<<'EOF'`, switches the expansion off. For now, the next level adds colour.
