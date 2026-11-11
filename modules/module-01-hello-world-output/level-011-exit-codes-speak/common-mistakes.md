# Common Mistakes

- **Printing an error but exiting 0.** The caller thinks everything is fine.
  Wrong: `echo "CRITICAL: queue"` (status 0)
  Right: `echo "CRITICAL: queue"` then `exit 2`
- **Putting exit before the message.** The script stops first and prints nothing.
  Wrong: `exit 2` then `echo "CRITICAL..."`
  Right: echo first, exit second.
- **Using a number above 255 or a negative one.** `exit 256` wraps around to 0 and `exit -1` becomes 255.
- **Writing exit = 2 or exit(2).** It is a plain command: `exit 2`.
