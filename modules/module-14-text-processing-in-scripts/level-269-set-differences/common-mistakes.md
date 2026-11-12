# Common Mistakes

- **Unsorted input.** `comm old.txt new.txt` on unordered lists prints `comm: file 1 is not in sorted order` (GNU) or silently wrong results (macOS). Sort both first.
- **Mixing up the columns.** `-13` means "hide 1 and 3", so what remains is column 2. If your "added" list shows removals, you swapped the flags or the file order.
- **Sorting in one locale and comparing in another.** If the list was sorted with `en_US.UTF-8` and comm runs in `C`, lines are reported as differences that are not. Use `LC_ALL=C` for both.
- **Duplicates in the lists.** A name that appears twice in one file and once in the other shows up as a difference. Use `sort -u` when the data may contain repeats.
- **Leading tabs in the output.** `comm old new` without suppression indents columns 2 and 3 with tabs. After `-13` or `-23` the single column has no indent, which is why a plain `sed 's/^/+ /'` is safe.
