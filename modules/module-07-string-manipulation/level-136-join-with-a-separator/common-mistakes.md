# Common Mistakes

- **A trailing (or leading) separator.** `joined+="$host$sep"` leaves a dangling
  `, ` at the end. Add the separator before each item except the first, using
  `${joined:+$sep}`.
- **Unquoted array expansion.** `for host in ${hosts[@]}` splits `gull anchor`
  into two items. Write `"${hosts[@]}"`.
- **Using `[*]` with a multi-character separator.** `IFS=", "; echo "${hosts[*]}"`
  joins with a lone comma, because only the first character of `IFS` is used.
- **Forgetting `shift`.** Without it the separator itself is the first "host" and
  ends up in the output.
