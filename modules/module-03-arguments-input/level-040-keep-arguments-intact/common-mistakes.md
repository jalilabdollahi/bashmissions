# Common Mistakes

- **Leaving `$@` unquoted.** Wrong: `bash fixtures/tag.sh $@` turns
  `"Tidewater Books"` into two labels and drops `""` altogether. Right:
  `bash fixtures/tag.sh "$@"`.
- **Using `"$*"` to forward.** `"$*"` glues everything into one word, so the
  printer shows a single label `<anchovy barracuda>`.
- **Quoting only part of it.** `"$@ "` or `"prefix $@"` mixes the list into a
  string. Keep `"$@"` standing alone as its own word.
- **Forgetting that `[ ]` or echo hide the bug.** `echo $@` looks fine because
  echo rejoins words with spaces. Test with a tool that prints one argument per
  line, like `tag.sh` or `printf '<%s>\n' "$@"`.
