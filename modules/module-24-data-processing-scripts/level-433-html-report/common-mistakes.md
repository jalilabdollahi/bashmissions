# Common Mistakes

- **Escaping `<` before `&`.** `s=${s//</&lt;}; s=${s//&/&amp;}` produces `&amp;lt;`. Always replace the `&` first.
- **Forgetting Bash 5.2's `&` rule.** `${s//&/&amp;}` then yields `&` followed by the text that was matched, or other garbage, depending on the version. Use `shopt -u patsub_replacement 2>/dev/null || true` first.
- **Inserting raw text.** `<td>$summary</td>` with `<script>` inside turns a data row into running code. Escape every cell, not just the one that seems risky.
- **Using `echo` for dozens of lines.** One `echo` per line makes the template hard to read and easy to break. A here-document shows the page as it will look. Note that the closing `EOF` must be alone on its line, with no leading spaces.
- **Losing the `\r` or the last line.** A Windows `\r` sits at the end of the last column and ends up inside `</td>`; a final line without newline vanishes unless the loop tests `|| [[ -n $time ]]`.
