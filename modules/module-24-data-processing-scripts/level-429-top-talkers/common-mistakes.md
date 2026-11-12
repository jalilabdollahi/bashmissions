# Common Mistakes

- **Sorting numbers as text.** `sort -k3,3r` ranks `9` above `10000`. Add `n`: `-k3,3nr`.
- **Leaving out the tie-break.** With only `-k3,3nr`, equal totals come out in an order that depends on the sort implementation. Add `-k1,1`.
- **Ranking with `uniq -c`.** That counts lines per client, not bytes. To weight by a column you need to add that column up, which is what the awk array does.
- **Letting `-` crash the sum.** Adding `"-"` is `0` in awk, but a client whose only line has `-` never gets a `bytes[]` entry and prints an empty total. Make sure the element exists.
- **Big totals in `%d`.** Some awks overflow at 2^31. Print byte sums with `%.0f`.
