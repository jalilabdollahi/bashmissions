# Common Mistakes

- **Forgetting `-o`.** `grep -E '...' file` prints entire lines, and every address
  would come with the whole sentence around it.
- **Not escaping the dot.** `([0-9]{1,3}.){3}[0-9]{1,3}` also matches `1x2x3x4`
  and, worse, extracts oddities such as `v123456`. Write `\.`.
- **Sorting without removing repeats.** `sort` alone keeps duplicates, and
  `uniq` alone only removes *adjacent* ones. Use `sort -u` (or `sort | uniq`).
- **A failing pipeline on empty input.** With `pipefail`, grep's exit status 1
  fails the whole pipe when nothing matches. Guard it with `|| true`.
- **Expecting numeric order.** `sort` compares text, so `10.1.2.3` lands before
  `9.9.9.9`. That is fine for deduplicating, but not a numeric sort.
