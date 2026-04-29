# Common Mistakes for Single vs Double Quotes

- Printing almost the right output, but not the exact expected text.
  The validator compares against two exact lines.

- Using double quotes for both lines.
  You must keep the first line literal with single quotes.

- Using single quotes for both lines.
  Then `$name` never expands in the second line.

- Solving only the happy path.
  Read the mission and verify the exact line order and punctuation.
