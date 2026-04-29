# Replace in String

Bash's parameter expansion replacement comes in four flavours:

| Form               | Replaces                                  |
|--------------------|-------------------------------------------|
| `${var/old/new}`   | first match of `old` only                 |
| `${var//old/new}`  | every match of `old`                      |
| `${var/#old/new}`  | match anchored to the start of the string |
| `${var/%old/new}`  | match anchored to the end of the string   |

`old` is a glob pattern. `new` is a literal replacement (no back-references like sed's `\1`).

```bash
text="hello world hello"

echo "${text/hello/hi}"     # hi world hello
echo "${text//hello/hi}"    # hi world hi
echo "${text/#hello/hi}"    # hi world hello   (start-anchored)
echo "${text/%hello/hi}"    # hello world hi   (end-anchored)

text="hello world"
echo "${text// /-}"          # hello-world      (replace all spaces)
echo "${text//[aeiou]/_}"    # h_ll_ w_rld     (glob class)
```

Useful idioms:

```bash
# slugify (basic):
title="My Awesome Post"
slug="${title// /-}"          # My-Awesome-Post
slug="${slug,,}"              # my-awesome-post

# normalize path separators:
path="C:\\Users\\file"
echo "${path//\\//}"        # C:/Users/file

# strip carriage returns from a Windows file:
clean="${input//$'\r'/}"
```

Limitations:

- No back-references, no capturing groups. For complex transforms, fall back to `sed` or `awk`.
- The `old` pattern is a glob; `*`, `?`, `[...]` work as expected, but regex syntax doesn't.
- All replacement forms operate in memory on the variable's value. To rewrite a file, read it into a variable first or use `sed -i`.
