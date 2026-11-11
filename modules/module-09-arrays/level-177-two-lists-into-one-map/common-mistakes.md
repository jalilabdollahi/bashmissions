# Common Mistakes

- **Zipping without a length check.** If `ips` is one line short, the last host gets an empty address and nothing complains. Compare `${#hosts[@]}` and `${#ips[@]}` first.
- **Looping with a hand counter.** `n=0; for h in "${hosts[@]}"; do t[$h]=${ips[n]}; n=$((n+1))` works, but `for i in "${!hosts[@]}"` is shorter and cannot drift.
- **Forgetting `declare -A`.** With a plain array every host name evaluates to 0 and the table has a single entry.
- **Sorting the output lines.** `printf '%s=%s\n' ... | sort` puts `dory2=...` before `dory=...` because `2` sorts before `=`. Sort the keys.
- **Reading with `$(cat)`.** `hosts=($(cat hosts.txt))` splits "old grouper" into two hosts and makes the lengths disagree.
