# Walkthrough: Don't Parse ls

## The plan
Keep the shape of the script and replace the source of the file names. A glob gives
the loop real, separate names; a file test then keeps only what we report.

## Why ls fails
`for name in $(ls $dir)` converts the listing to text, then word splitting cuts
it at every space. `x-ray scan 1.txt` becomes three names. Names starting with a
dash, brackets or newlines each break something else. You cannot reliably get the
names back from the text.

## Steps
1. Loop over the glob, with the directory quoted:
   ```bash
   for f in "$dir"/*; do
   ```
2. Skip directories and the "no match" case:
   ```bash
   if [ -f "$f" ]; then
   ```
3. Measure the file: `size=$(wc -c < "$f")`. Reading from stdin (`<`) stops `wc`
   from printing the file name, and the `$(( ))` arithmetic removes macOS's padding.
4. Print only the base name with `${f##*/}`:
   ```bash
   printf '%s: %d bytes\n' "${f##*/}" "$((size))"
   ```
5. Keep the final `empty` message.

Hidden files are not matched by `*`, which is what the spec asks for.

## Try it
```
mkdir up; echo hi > "up/x-ray scan 1.txt"; mkdir up/sub
./solution.sh up
```

## Alternative
`find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' f` is the right
tool for recursion and for hidden files, but for one level of plain files a glob is
shorter and keeps variables in the main shell.
