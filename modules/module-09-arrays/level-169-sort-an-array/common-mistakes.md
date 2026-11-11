# Common Mistakes

- **Sorting with `echo`.** `echo "${items[@]}" | sort` sorts one line of text, which changes nothing. Items must go in one per line: `printf '%s\n' "${items[@]}" | sort`.
- **Forgetting `-n` for numbers.** Without it `80` sorts after `8080` and `443` before `80`.
- **Assigning with `$(...)`.** `sorted=($(... | sort))` splits "grouper a" into two elements. Use `mapfile -t sorted < <(...)`.
- **Empty input producing an element.** `printf '%s\n' "${empty[@]}" | sort` returns one blank line, so `sorted` gets one empty element and the count says 1.
- **Piping into `mapfile`.** `... | sort | mapfile -t sorted` leaves `sorted` empty in the main shell.
