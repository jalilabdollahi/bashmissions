# Common Mistakes

- **Single percent for the first label.** `${name%.*}` only removes the last
  label: `db-01.prod.example` becomes `db-01.prod`. Use `%%`.
- **Dropping the last line.** Without `|| [[ -n $name ]]`, input that does not end
  in a newline loses its final entry because `read` fails on it.
- **Forgetting `IFS=`.** Plain `read name` trims leading and trailing blanks, so
  the printed full name would differ from the input. Write `IFS= read -r`.
- **Assuming a trailing dot is a label.** `barracuda.example.` has its first dot
  after `barracuda`, so `%%.*` gives `barracuda`; no special handling is needed.
