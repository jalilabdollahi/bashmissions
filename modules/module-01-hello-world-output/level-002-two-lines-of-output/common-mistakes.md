# Common Mistakes

- **Putting two lines of text in one echo without meaning to.** The text is printed as given on a single line.
  Wrong: `echo "HANDOVER NOTE Pager: Ollie"`
  Right: two commands, `echo "HANDOVER NOTE"` and `echo "Pager: Ollie"`
- **Writing the lines in the wrong order.** If the check says line 2 is wrong, compare the order against the objective, not only the spelling.
- **Forgetting echo on a line.** `Pager: Ollie` alone makes Bash look for a program called `Pager:` and print "command not found".
- **Typing a semicolon-joined line and expecting a break.** `echo "a"; echo "b"` still works as two commands, but one per line is much easier to read.
