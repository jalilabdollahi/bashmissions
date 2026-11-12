# Walkthrough: HTML Report

## The plan
Two jobs: turn each CSV row into a safe table row, then pour the rows into a
fixed page template. Safety comes from escaping every cell; the template
comes from a here-document.

## Step by step
1. **An escape function.** HTML gives three characters special meaning that matter
   for text: `&` starts an entity, `<` and `>` delimit tags. Replace `&` with
   `&amp;`, `<` with `&lt;`, `>` with `&gt;`. The ampersand is first because
   the other two replacements *produce* ampersands; reversing the order turns
   `<` into `&amp;lt;` and the page shows the word "&lt;" instead of "<".
   The function stores its answer in a variable (`escaped`) instead of printing
   it, which avoids starting a subprocess for every cell.

2. **Bash 5.2 and `&`.** In Bash 5.2 an unescaped `&` in the replacement part of
   `${v//a/b}` means "the matched text". `shopt -u patsub_replacement` turns
   that off. Bash 4 and 5.0 do not have the option, so errors are silenced.

3. **Read rows.** `IFS=, read -r time server summary` gives the third variable
   everything after the second comma, so commas in a summary survive. Remove
   the `\r` from `summary`, the last variable. The loop condition handles a
   final line without newline. Blank lines are skipped.

4. **Build the rows.** Append one `<tr>` line per incident to `rows` and count
   them.

5. **The template.** `cat <<EOF` prints the page; `${rows}` and `$count` are
   expanded once. The text that came *from* the variables is never expanded
   again, so a summary such as `$(rm -rf ~)` is printed literally.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
s='1 < 2 & 3 > 2'; s=${s//&/&amp;}; s=${s//</&lt;}; echo "$s"
./solution.sh incidents.csv > report.html
```

## Alternative
`sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'` escapes a whole stream
in one call. It is fine for a file at a time; the pure-Bash function avoids one
process per cell when you do the work in a loop.
