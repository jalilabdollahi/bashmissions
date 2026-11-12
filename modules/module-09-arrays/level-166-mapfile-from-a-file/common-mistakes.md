# Common Mistakes

- **Loading with `$(cat file)`.** `hosts=($(cat hosts.txt))` splits at every space and drops blank lines. "old dory" becomes two elements.
  Right: `mapfile -t hosts < hosts.txt`
- **Leaving out `-t`.** Every element then ends with a newline, so `[[ ${hosts[0]} == anchovy ]]` is false even though it looks right when printed.
- **Piping into mapfile.** `cat hosts.txt | mapfile -t hosts` leaves `hosts` empty in your script (subshell). Use `< hosts.txt`.
- **Reading the last element of an empty array.** `${hosts[-1]}` on an empty array gives an error ("bad array subscript"). Check the length first.
- **Forgetting the quotes on the path.** `mapfile -t hosts < $file` breaks for paths with spaces. Right: `< "$file"`.
