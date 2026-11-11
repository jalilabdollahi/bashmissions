# Common Mistakes

- **Reaching for old-style backticks.**
  Wrong: `` first=`sort f | head -n 1` `` works, but backticks cannot be nested cleanly and are easy to mistake for quotes.
  Right: `first=$(sort f | head -n 1)`.
- **Forgetting the dollar sign.**
  Wrong: `first=(sort fixtures/servers.txt)` creates an array, not a captured string.
  Right: `first=$(sort fixtures/servers.txt)`.
- **Expecting a live view.**
  Capturing `count=$(wc -l < file)` freezes the number. Appending to the file afterwards does not change `$count`.
- **Space after the equals sign.**
  Wrong: `first= $(sort f | head -n 1)` runs the output as a command.
  Right: `first=$(sort f | head -n 1)`.
