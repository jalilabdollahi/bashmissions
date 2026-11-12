# Common Mistakes

- **Using two arrows for a string.** `<<` starts a here-document and waits for a closing word.
  - Wrong: `wc -w << "$text"`
  - Right: `wc -w <<< "$text"`
- **Forgetting the newline that `<<<` adds.** Byte counts are one higher than the string length.
  - Wrong: expecting `wc -c <<< "abc"` to print 3
  - Right: it prints 4; use `${#text}` for the length
- **Leaving the variable unquoted.** Spaces get squeezed.
  - Wrong: `tr a-z A-Z <<< $text`
  - Right: `tr a-z A-Z <<< "$text"`
- **Mixing in a file name.** A here-string is the data, not a path.
  - Wrong: `wc -w <<< ticket.txt` counts one word, the file name
  - Right: `wc -w < ticket.txt` for a file
