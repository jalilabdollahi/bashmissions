# Common Mistakes

- **Off-by-one on the range size.** Both ends are included.
  - Wrong: `size=$(( high - low ))` never produces HIGH
  - Right: `size=$(( high - low + 1 ))`
- **Forgetting to shift by LOW.** `RANDOM % size` alone starts at zero.
  - Wrong: `echo $(( RANDOM % size ))` for a range of 5 to 45
  - Right: `echo $(( low + RANDOM % size ))`
- **Reading `$RANDOM` twice in one formula.** Each read is a different number.
  - Wrong: `$(( low + RANDOM % (high - RANDOM) ))` mixes two draws
  - Right: one `RANDOM`, with the range worked out beforehand
- **Seeding inside the loop.** The same seed gives the same number every time.
  - Wrong: `RANDOM=$seed` as the first line of each loop pass: every slot is identical
  - Right: seed once before the loop
