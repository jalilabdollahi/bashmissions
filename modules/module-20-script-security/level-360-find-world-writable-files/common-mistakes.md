# Common Mistakes

- **Exact match instead of bit test.** Wrong: `find . -perm 002` finds only files with mode exactly 002 (almost none). Right: `find . -perm -002`.
- **Grepping ls output.** Wrong: `ls -lR | grep 'rw-rw-rw-'` misses 0602, shows names split by spaces, and loses the folder part of the path. Right: `find ... -perm -002`.
- **Forgetting `-type f`.** Wrong: folders with mode 777 (very common, like /tmp) flood the report. Right: `-type f` when the question is about files.
- **Unsorted output.** Wrong: relying on find's traversal order; it differs between filesystems, so the report changes between runs. Right: pipe through `sort`.
- **Looping over unquoted output.** Wrong: `for f in $(find ...)` splits `menu list.txt`. Right: `mapfile -t hits < <(find ...)` and iterate over `"${hits[@]}"`.
