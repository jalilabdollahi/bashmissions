# Common Mistakes

- **Spacing the words but not quoting.** The gaps are removed before echo runs.
  Wrong: `echo GULL   AND   ANCHOR`
  Right: `echo "GULL   AND   ANCHOR"`
- **Quoting each word separately.** Every quoted word is still a separate argument, so single spaces come back.
  Wrong: `echo "GULL"   "AND"   "ANCHOR"`
  Right: `echo "GULL   AND   ANCHOR"`
- **Leaving a quote unclosed.** Bash waits for more input and shows a `>` prompt, or the script fails with "unexpected EOF". Count your opening and closing quotes.
- **Miscounting spaces.** The expected line has exactly three between words. Two or four fails the exact check.
