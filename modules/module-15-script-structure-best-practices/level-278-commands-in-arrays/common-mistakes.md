# Common Mistakes

- **Storing a command in a string.** Wrong: `cmd="find $dir -name $p"; $cmd`. A pattern with a space or star is torn apart. Right: `cmd=(find "$dir" -name "$p"); "${cmd[@]}"`.
- **Expanding the array without quotes.** Wrong: `${cmd[@]}` splits and globs every element again. Right: `"${cmd[@]}"`.
- **Using `${cmd[*]}`.** It joins everything into one word. Right: `[@]` to run, `[*]` only to print for a human.
- **Forgetting to quote the parentheses.** Wrong: `args+=( ( -name x ) )` is a syntax error in bash. Right: `args+=( '(' -name x ')' )`.
- **Putting several words in one element.** Wrong: `args+=( "-name $p" )` gives find a single argument called `-name Q3 *`. Right: `args+=( -name "$p" )`, two elements.
