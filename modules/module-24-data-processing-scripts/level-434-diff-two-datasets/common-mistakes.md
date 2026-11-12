# Common Mistakes

- **Diffing text instead of keys.** `diff old.csv new.csv` marks every line as changed when the file was merely re-sorted. Compare by key and let order be irrelevant.
- **Trusting `FNR == NR` with an empty first file.** The second file then satisfies the test and is loaded as OLD, so every row looks unchanged. Check `[[ -s file ]]` first.
- **Reading the array to test a key.** `if (old[k] == "")` creates `old[k]`, so later loops see keys that were never in the file. Use `(k in old)`.
- **Printing in for-in order.** The report would change from run to run. Prefix each line with its key and tab, `sort -t "$tab" -k1,1`, then `cut -f2-`.
- **`grep -c` under `set -e`.** `n=$(... | grep -c '^+ ')` aborts the script when there are no additions. Append `|| true`.
