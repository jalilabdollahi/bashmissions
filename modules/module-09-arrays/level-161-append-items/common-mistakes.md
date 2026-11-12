# Common Mistakes

- **Forgetting the brackets.** `pool+="$line"` glues text onto element 0. Output shows `anchovydory barracuda` and a total that never grows.
  Right: `pool+=("$line")`
- **Assigning with `=` inside the loop.** `pool=("$line")` replaces the whole array with one element on every pass.
- **Leaving out the quotes.** `pool+=($line)` splits "flounder two" into two elements and drops blank lines.
  Right: `pool+=("$line")`
- **Piping the input into the loop.** `cat names | while read ...; do pool+=(...); done` fills a copy of the array in a subshell. After the loop the pool is unchanged.
- **Losing the last line.** If the input does not end in a newline, `while read -r line` ends one line early. Add `|| [[ -n $line ]]`.
