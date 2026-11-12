# Common Mistakes

- **Using `$0` for the file name.** Wrong: `echo "defined in $0"`. When another script sources the file, it prints that script's name (or `bash`). Right: `${BASH_SOURCE[0]}`.
- **Calling `main "$@"` unconditionally.** Sourcing the file then runs main, prints the usage error and may call `exit`, which closes the *caller's* shell. Right: wrap it in the `BASH_SOURCE`/`$0` comparison.
- **Leaving out the quotes in the guard.** `[[ ${BASH_SOURCE[0]} == $0 ]]` treats the right side as a pattern. Quote `"$0"` so a path with glob characters is compared literally.
- **Forgetting the `[0]`.** `$BASH_SOURCE` alone happens to give element 0, but the habit hides what the array is. Write `${BASH_SOURCE[0]}`; entry 1 is the caller's file.
- **Printing the full path in the label.** `${BASH_SOURCE[0]}` is `./solution.sh` or `/some/dir/solution.sh` depending on how it was started. Use `basename` when you want a stable name.
