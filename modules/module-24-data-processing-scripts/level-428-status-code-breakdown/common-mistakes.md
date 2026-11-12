# Common Mistakes

- **Walking the array that exists.** `for (k in count) print ...` omits empty classes and prints in a shuffled order. Loop over a fixed list of names.
- **Dropping the lines you cannot classify.** If bad lines are ignored, the percentages add up to 100 over the wrong total. Count them as `other`.
- **Dividing by `total` without checking.** An empty log gives `100 * 0 / 0`, which is a fatal awk error. Use `(total > 0) ? ... : 0`.
- **Forgetting `%%` in printf.** `printf "%.1f%"` prints a broken format on some awks. A literal percent sign is `%%`.
- **Classifying with arithmetic on junk.** `int($4 / 100)` turns `abc` into class 0 and `600` into class 6. Validate the shape with a regex first.
