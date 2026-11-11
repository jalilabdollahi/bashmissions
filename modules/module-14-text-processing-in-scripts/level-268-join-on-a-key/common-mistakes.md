# Common Mistakes

- **Joining unsorted files.** `join -t, customers.csv invoices.csv` with unordered input drops matches. Always `sort` both on the key first.
- **Sorting the whole line instead of the key.** `sort file` may order `C1,x` and `C10,y` differently from the keys `C1` and `C10`. Use `sort -t, -k1,1`.
- **Forgetting -t,.** Without it join splits at spaces, so `Gull & Anchor Pub` becomes separate fields and the key may be wrong or the output garbled.
- **Different sort and join orders.** If the files were sorted in one locale (say `en_US.UTF-8`) and joined in another, matches vanish. Use `LC_ALL=C` for both.
- **Expecting unmatched rows.** By default only matching keys are printed. Keep the left file's extra rows with `-a 1`, or list just the strays with `-v 1`.
