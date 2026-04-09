# Common Mistakes for The Certificate Watchdog

- Printing almost the right output, but not the exact expected text.
  The validator compares against output like `the-certificate-watchdog:467:expert:ok`.

- Forgetting to quote variables.
  Handle both the default mode and the optional second argument, and keep the missing-file path quiet.

- Returning the wrong exit status.
  A script can print the right text and still fail if it exits with the wrong code.

- Solving only the happy path.
  Read the mission again and make sure you also handle missing inputs or optional arguments when the level asks for them.
