# Common Mistakes

- **Copying both ways without a helper.**
  Wrong: `PRIMARY=$STANDBY; STANDBY=$PRIMARY` leaves both variables equal to the old standby.
  Right: save one value in `tmp` first.
- **Using the temporary after it was overwritten.**
  Wrong: `tmp=$PRIMARY; PRIMARY=$STANDBY; tmp=$STANDBY; STANDBY=$tmp` - `tmp` was reused too early.
  Right: `STANDBY=$tmp` immediately after the second assignment.
- **Only printing in reverse order.**
  `echo "primary=$STANDBY"` looks swapped but nothing changed; any later line that reads `$PRIMARY` still sees the old value.
- **Reaching for a dollar sign on the left.**
  Wrong: `$PRIMARY=$STANDBY` - the left side is a name, not a value.
  Right: `PRIMARY=$STANDBY`.
