# Common Mistakes for String Length

- Using `expr length "$x"` or `echo "$x" | wc -c`. The first is slow (subprocess); the second adds 1 for the newline that `echo` emits. `${#x}` is correct, fast, and exact.

- Forgetting the `#` is **inside** the braces: `${#name}` is right, `#${name}` is wrong (and parsed as a comment).

- Confusing `${#arr[@]}` (number of array elements) with `${#arr[0]}` (length of first element). Same operator, different meaning depending on what comes after.

- Counting bytes when you wanted characters (or vice versa). Bash's `${#x}` counts characters per the current locale. To count bytes, set `LC_ALL=C` for that one command: `LC_ALL=C; echo ${#text}`.

- Trying it on an unset variable with `set -u` enabled: `${#missing}` aborts the script. Provide a fallback: `${#missing-}` (empty default) → length 0.
