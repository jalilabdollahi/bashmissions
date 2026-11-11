# Common Mistakes

- **Forgetting that IFS must be set for `read`.** `read -ra tags` on
  `web,eu-west` gives one element `web,eu-west`, because the default splits on
  spaces. Right: `IFS=, read -ra tags`.
- **Putting `IFS=,` on its own line.** `IFS=,` alone changes it for the rest of
  the script, which breaks later splitting. Write it directly before `read`.
- **Reading the count as `$#tags`.** The size of an array is `${#tags[@]}`.
  `$tags` alone is just the first element.
- **Off-by-one on the last element.** With three tags the last index is 2, not 3.
  Use `${tags[-1]}` or `${tags[${#tags[@]}-1]}`.
