# Common Mistakes for Print a Message

- Printing almost the right output, but not the exact expected text.
  The validator compares against output like `Message: Hello Bash`.

- Forgetting to quote variables.
  Use `"$1"` so spaces in arguments stay intact.

- Using the wrong argument.
  This level uses only the first argument (`$1`).

- Solving only the happy path.
  Read the mission again and match the exact prefix and punctuation.
