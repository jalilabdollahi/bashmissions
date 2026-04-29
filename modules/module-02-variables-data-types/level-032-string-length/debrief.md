# String Length

`${#name}` is the **string length** parameter expansion. It returns an integer count of characters in the value.

```bash
text="hello"
echo "${#text}"   # 5

empty=""
echo "${#empty}"  # 0

echo "${#1}"      # length of the first positional parameter
```

Works on positional parameters and on regular variables. For arrays, `${#arr[@]}` and `${#arr[*]}` return the number of *elements*, not characters.

Counting subtleties:

- Counts characters, not bytes — in a UTF-8 locale `${#café}` is `4`, not `5`.
- Counts every character including spaces and special characters.
- Newlines, if present, count too: `${#$'a
b'}` is `3`.

Use it instead of `echo "$x" | wc -c` (which adds 1 for the trailing newline) or `expr length "$x"` (slow, external).

Common patterns:

```bash
[[ ${#input} -lt 8 ]] && echo "too short, must be at least 8 characters"
[[ -z "$x" ]] && [[ ${#x} -eq 0 ]]   # equivalent emptiness checks
```
