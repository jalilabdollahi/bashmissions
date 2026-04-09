# Common Mistakes for Per-User Config

- Printing almost the right output, but not the exact expected text.
  The validator compares against output like `per-user-config:346:processed:3`.

- Forgetting to quote variables.
  Check that the input file exists before printing anything, and return exit code `1` when it does not.

- Returning the wrong exit status.
  A script can print the right text and still fail if it exits with the wrong code.

- Solving only the happy path.
  Read the mission again and make sure you also handle missing inputs or optional arguments when the level asks for them.
