# Debrief: sed Back-References

Capture groups are not only for reading; they are for **rearranging**. In
`[[ =~ ]]` you took pieces out into `BASH_REMATCH`. In `sed` you put them straight
back into the replacement: `\1` means "whatever the first group matched". Match
the whole date once, name its parts, and write the new layout.

The mental model is a template: the pattern is a mould with labelled blanks, and
the replacement is a different mould that uses the same labels. Anything the
pattern did not match is untouched, which is why the sentence around the date
survives unchanged. This is much safer than text surgery by position.

Some details worth remembering:

- Groups are numbered by their opening parenthesis, left to right, up to `\9`.
- `&` in the replacement stands for the *entire* match, handy for wrapping text:
  `s/ERROR/[&]/` gives `[ERROR]`.
- If you need a literal `&` in the replacement, write `\&`.
- Precision protects you. Because `{2}` and `{4}` are exact, the look-alikes
  `7/11/2024` and `07/11/24` are not rewritten into garbage.
- It does not *validate*. `99/99/2024` is converted. Reformatting and validating
  are separate jobs (see level 224 for the second).

Real-world uses: swapping `Last, First` names, turning `key=value` into JSON-ish
text, normalising version tags, reformatting dates and phone numbers.

Going further: so far captures were precise because the format was fixed. Next
you will capture text of unknown length between delimiters, which needs a new
trick.
