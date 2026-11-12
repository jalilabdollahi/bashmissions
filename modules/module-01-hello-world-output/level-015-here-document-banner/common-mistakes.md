# Common Mistakes

- **Indenting the closing EOF.** Bash will not recognise it and reads on to the end of the file.
  Wrong: `    EOF`
  Right: `EOF` at the very start of the line
- **Different names at the start and the end.** `cat <<EOF ... END` never closes.
- **Typing text after the closing marker.** `EOF .` or `EOF;` is not the delimiter.
- **Using `cat < EOF` with a single `<`.** That tries to read a file named EOF. Two angle brackets, no space needed: `<<EOF`.
