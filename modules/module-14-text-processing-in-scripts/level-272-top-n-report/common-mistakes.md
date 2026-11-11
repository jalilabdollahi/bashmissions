# Common Mistakes

- **Counting before sorting.** `awk ... | uniq -c` gives runs, not totals. Insert `sort` before `uniq -c`.
- **Ranking before counting.** `sort -rn` on the raw names does not rank anything; the ranking sort must come after `uniq -c`.
- **Leaving the uniq -c padding.** `awk '{ print $2 }'` works with it, but `cut -d' ' -f1` and comparisons do not, and the padding width differs per platform. Normalise with `sed 's/^ *//'`.
- **No tie-breaker.** `sort -rn` alone orders equal counts arbitrarily, so the leaderboard shuffles between runs or machines. Name a second key: `sort -k1,1nr -k2,2`.
- **Head too early.** Putting `head -n "$n"` before the ranking sort keeps the first N names of the log, not the top N. The cut-off belongs after the ranking.
- **Surprise from head and pipefail.** `head` exits as soon as it has N lines. On a very large input, an earlier stage can be killed by SIGPIPE and `set -o pipefail` reports status 141. Here the data is small; for big logs tolerate it with `|| true` on that stage.
