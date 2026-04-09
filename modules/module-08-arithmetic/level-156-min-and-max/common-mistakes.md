# Common Mistakes for Min and Max

- Printing almost the right output, but not the exact expected text.
  The validator compares against output like `LEVEL 156: Min and Max | alpha | beta`.

- Forgetting to quote variables.
  Use `"$1"` and `"$2"` so spaces in arguments stay intact.

- Returning the wrong exit status.
  A script can print the right text and still fail if it exits with the wrong code.

- Solving only the happy path.
  Read the mission again and make sure you also handle missing inputs or optional arguments when the level asks for them.
