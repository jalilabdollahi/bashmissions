# Common Mistakes

- **Using the variable before defaulting it.** Wrong: `seconds=$POLL_SECONDS`; with `set -u` the script dies with "unbound variable" instead of using 30. Right: `${POLL_SECONDS:-30}`.
- **Forgetting the colon.** Wrong: `${POLL_SECONDS-30}` leaves an exported empty string empty. Right: `${POLL_SECONDS:-30}` treats empty like unset.
- **Doing arithmetic on unchecked text.** Wrong: `(( POLL_SECONDS > 3600 ))` when it is `abc` or `1+1`. Right: match `^[0-9]+$` first.
- **Validating after use.** Wrong: starting the poll loop and then noticing the interval is 0. Right: all checks happen before any side effect.
- **A vague error.** Wrong: `echo "bad config"`. Right: name the variable and the rule, on stderr, with exit 2.
