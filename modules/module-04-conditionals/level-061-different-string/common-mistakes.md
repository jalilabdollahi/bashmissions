# Common Mistakes

- **Sending the refusal to stdout.** Everything that captures output then treats the error as data.
  - Wrong: `echo "refusing to run on $host"`
  - Right: `echo "refusing to run on $host" >&2`
- **Printing the error but not exiting.** The guard is useless if the script carries on afterwards.
  - Wrong: `if [[ $host != dory ]]; then echo "no" >&2; fi` followed by the real work
  - Right: add `exit 1` inside the block
- **Writing `!=` and `=` the wrong way round.** `[[ $host =! dory ]]` is a syntax error.
  - Wrong: `[[ $host =! dory ]]`
  - Right: `[[ $host != dory ]]`
- **Exiting with 0 on refusal.** Status 0 tells cron and CI "all went well".
  - Wrong: `exit 0` (or no exit at all) after the refusal
  - Right: `exit 1`
