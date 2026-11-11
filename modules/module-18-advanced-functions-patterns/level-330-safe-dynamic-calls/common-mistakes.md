# Common Mistakes

- **Checking only that the function exists.** Wrong: `declare -F "do_$action" && "do_$action" "$target"` happily runs `do_wipe`. Right: compare against an allow-list you wrote; existence is not permission.
- **Unquoted right side of `==`.** Wrong: `[[ $item == $candidate ]]` treats the input as a glob pattern, so `*` is "allowed". Right: `[[ $item == "$candidate" ]]`.
- **Prefix or substring matching.** Wrong: `[[ " restart reload status " == *" $action "* ]]` works for words but `[[ $allowed == *$action* ]]` lets `stat` or `re` through. Right: loop and compare whole words.
- **Reaching for eval.** Wrong: `eval "do_$action $target"` turns `restart; rm -r x` into two commands. Right: `"do_$action" "$target"` after the check, with no eval.
- **Aborting on the first refused line.** One bad request should not drop the rest of the queue. Right: report on stderr, remember it in a flag, `continue`, and set the exit status at the end.
