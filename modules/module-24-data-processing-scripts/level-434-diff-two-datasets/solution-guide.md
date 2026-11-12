# Walkthrough: Diff Two Datasets

## The plan
Put both files into awk arrays keyed by the first column. Walk the new array to
find additions and changes, walk the old array to find removals. Collect the
findings as `key<TAB>text`, sort by key, and add a summary.

## Step by step
1. **Fail early.** `[[ -s $f ]]` is true for a non-empty file. An empty file
   would also break `FNR == NR` (explained below), so it is rejected with a
   clear message, OLD first. Then the two header lines are compared with `\r`
   removed; different headers mean the columns do not line up and the
   comparison would be meaningless.

2. **Load.** `FNR == NR` is true only while awk reads the first file, because
   `FNR` restarts at 1 for each file while `NR` keeps counting. If the first
   file were empty, the *second* file would satisfy `FNR == NR` and be loaded as
   OLD; that is why emptiness is checked first. Headers (`FNR == 1`) and blank
   lines are skipped. `rest` is the row after the first comma. Assigning
   `old[$1] = rest` means that for a repeated key the last row wins.

3. **Compare in `END`.** `(k in old)` tests membership without creating the
   element. Keys only in `new` are additions, keys in both with a different
   `rest` are changes, and a second loop over `old` finds removals.

4. **Order.** `for (k in ...)` order is unspecified, so each finding carries its
   key and a tab in front, and `sort -t "$tab" -k1,1` sorts by the key
   alone; `cut -f2-` removes it.

5. **Summary.** If the sorted text is empty: `no differences`. Otherwise print
   it and count lines by their prefix with `grep -c`. A count of zero makes
   `grep` exit 1, which `|| true` absorbs.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
./solution.sh old.csv new.csv
diff <(sort old.csv) <(sort new.csv)     # the noisy alternative
```

## Alternative
`comm -3 <(sort old) <(sort new)` lists lines unique to each file, but a
changed row shows up as one removal plus one addition, with no link between
them, and the output has no key order or summary. When rows have identity (a
key), compare by identity.
