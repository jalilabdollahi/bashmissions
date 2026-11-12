# Common Mistakes

- **Random rollouts.** `(( RANDOM % 100 < rollout ))` gives the same user a different answer on every request. Hash a stable key (`cksum` of flag and user) instead.
- **Substring matching on lists.** `[[ $allow == *ann* ]]` is true for `joanne`. Wrap the list in commas and match `*",ann,"*`.
- **Putting allow before the kill switch.** Then an allow-listed user still sees a feature the operator just switched off. The order of the rules is the contract.
- **Using `<=` for the bucket.** With buckets 0..99, `bucket <= rollout` turns on N+1 percent, and `rollout=0` is never "nobody".
- **Stopping at the first bad line.** Reporting one error per run makes fixing a config an endless loop. Collect all problems, then exit once.
- **Leading zeros in numbers.** `rollout=08` makes `(( 08 > 100 ))` an octal error. Force decimal with `10#$val`.
