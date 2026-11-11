# Common Mistakes

- **Dropping the braces.** `echo "$rack[2]"` prints the first machine followed by `[2]`.
  Right: `echo "${rack[2]}"`
- **Counting from one.** `${rack[3]}` is the fourth element, not the third. Third is `[2]`.
- **Using a bare array name.** `echo "$rack"` prints only element 0, not the whole rack.
- **Computing the last index the long way and getting it wrong.** `${rack[${#rack[@]}]}` is one past the end and prints an empty line. Right: `${rack[-1]}` or `${rack[${#rack[@]}-1]}`.
- **Forgetting the quotes in `rack=($@)`.** A machine called "marlin two" becomes two elements and shifts every later index. Right: `rack=("$@")`.
