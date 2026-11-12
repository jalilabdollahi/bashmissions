# Common Mistakes

- **Using only half the pair.** Both sides must use NUL.
  - Wrong: `find ... -print0 | xargs cksum` (xargs splits on blanks and sees NULs as junk)
  - Wrong: `find ... | xargs -0 cksum` (one giant "name" with newlines in it)
  - Right: `find ... -print0 | xargs -0 cksum`
- **Fixing it with quotes.** `ls | sed 's/.*/"&"/' | xargs ...` breaks at the first name that contains a quote.
  - Right: NUL separators.
- **Letting the shell expand the pattern.** An unquoted `-name *.log` is expanded by the shell in the *current* folder before find runs.
  - Wrong: `find "$dir" -name *.log`
  - Right: `find "$dir" -name '*.log'`
- **Forgetting `-type f`.** A folder called `old.log` is matched and `cksum` complains about it.
  - Right: `-type f`
- **Parsing `ls` output.** It cannot represent every name safely.
  - Right: let `find` produce the list.
