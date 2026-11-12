# Common Mistakes

- **Indenting the closing word.** It is then not recognised and the script reads on to the end of file.
  - Wrong: `    EOF` (spaces before it)
  - Right: `EOF` at the very start of the line
- **Trailing characters after the closing word.**
  - Wrong: `EOF ` with a trailing space, or `EOF;`
  - Right: nothing but `EOF`
- **Quoting the delimiter and then expecting variables.**
  - Wrong: `cat <<'EOF'` then `Dear $customer,` prints the literal `$customer`
  - Right: `cat <<EOF` when you want values filled in
- **Mixing up `<<` and `<<<`.** One takes a block, the other a single string.
  - Wrong: `cat <<< EOF` prints the word EOF
  - Right: `cat <<EOF`
