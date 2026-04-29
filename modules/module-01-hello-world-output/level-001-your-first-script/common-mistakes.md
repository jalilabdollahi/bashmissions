# Common Mistakes for Your First Script

- Printing almost the right output, but not the exact expected text.
  The validator compares against `Hello, BashMissions!`.

- Adding extra output.
  Even a second line like `Done` can fail exact checks.

- Returning the wrong exit status.
  A script can print the right text and still fail if it exits with the wrong code.

- Overcomplicating a beginner level.
  This mission is intentionally simple: one exact greeting line.
