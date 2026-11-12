# Common Mistakes

- **Forgetting `shopt -s extglob`.** Without it `+([[:space:]])` is not a pattern
  and nothing is trimmed, or Bash complains about a syntax error. Enable it before
  the loop (and in a script, not only in your terminal).
- **Single-character trimming.** `${line# }` removes one space, not all of them.
  Use `${line##+([[:space:]])}`.
- **Trimming the wrong end.** `#`/`##` work on the front, `%`/`%%` on the back. Doing
  only one gives `[Tidewater Books   ]`.
- **Letting `read` do it silently.** Plain `read line` already trims the ends,
  which hides bugs elsewhere. Use `IFS= read -r line` and trim explicitly.
