# Common Mistakes

- **Letting another command sneak in.** Wrong: `grep -qx ... "$f"; echo "checking"; status=$?` saves the status of `echo` (always 0). Right: `status=$?` on the line directly after grep.
- **Testing the output instead of the status.** Wrong: `[[ -n $(grep maintenance=on "$f") ]]` treats an unreadable file like "no match". Right: use `-q` and read `$?`; 2 is different from 1.
- **Forgetting `-x`.** Wrong: `grep -q 'maintenance=on'` also matches `maintenance=online`. Right: `grep -qx 'maintenance=on'` demands the whole line.
- **Reading `$?` twice.** Wrong: `if [ $? -eq 0 ]; then ...; elif [ $? -eq 1 ]` - the first `[` already replaced it. Right: `status=$?` once, then compare `$status`.
- **Using `set -e` with a command whose 1 is an answer.** The script dies at grep before you can look at the status.
