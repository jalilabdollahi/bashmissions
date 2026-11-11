# Common Mistakes

- **Check-then-write.** Wrong: `[[ -e $f ]] || echo me > "$f"` lets a second process in between. Right: `set -o noclobber` and a bare `> "$f"` in an `if`.
- **Using `>|`.** Wrong: `echo me >| "$f"` forces the overwrite and cancels noclobber. Right: plain `>`.
- **Noclobber set after the write.** Wrong: setting the option on the line below the redirection protects nothing. Right: set it first.
- **Letting `set -e` hide the message.** Wrong: a bare failed redirect ends the script with the shell's own wording and exit code. Right: put it in an `if` and report in your own words.
- **Using `>>` as the exclusive create.** Wrong: append mode creates *or* extends the file, so there is no failure to detect. Right: `>` under noclobber.
