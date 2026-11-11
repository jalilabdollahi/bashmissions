# Common Mistakes

- **Using `exit` instead of `break`.** It ends the whole script, so anything after the loop never runs.
  Wrong: `exit` inside the loop when you still need to print a summary below it
  Right: `break` leaves only the loop
- **Putting `break` before the message.** Nothing after `break` in the same round runs.
  Wrong: `break; echo "STOP: $server is down"`
  Right: `echo "STOP: $server is down"; break`
- **Forgetting the `fi`.** An `if` without `fi` swallows the rest of the script and ends in a syntax error.
- **Breaking without a condition.** A bare `break` at the top of the body leaves the loop in the first round, so only the first server is ever handled.
