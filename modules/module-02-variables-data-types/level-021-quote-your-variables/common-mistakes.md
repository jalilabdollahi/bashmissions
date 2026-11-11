# Common Mistakes

- **Quoting the message but not the file name.**
  Wrong: `echo "Hi, $CUSTOMER" > $CUSTOMER.txt` fails with `ambiguous redirect` on a name with spaces.
  Right: `> "$CUSTOMER.txt"`.
- **Using single quotes.**
  Wrong: `echo 'Welcome, $CUSTOMER'` prints the dollar sign and the word literally.
  Right: double quotes - `echo "Welcome, $CUSTOMER"`.
- **Assuming it only matters for spaces.**
  A value of `*` or `a?` is silently replaced by matching file names when unquoted. The output looks plausible, which makes it worse.
- **Quoting too little of the word.**
  `"$CUSTOMER".txt` happens to work, but `$CUSTOMER".txt"` does not. Put the whole word in one pair of quotes.
