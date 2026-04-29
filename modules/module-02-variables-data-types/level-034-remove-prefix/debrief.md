# Remove Prefix

Bash has two **prefix-stripping** parameter expansions:

| Form              | Removes from the start...                         |
|-------------------|---------------------------------------------------|
| `${var#pattern}`  | shortest match of `pattern`                       |
| `${var##pattern}` | longest match of `pattern`                        |

The `pattern` is a **shell glob**, not a regex: `*`, `?`, `[abc]`, brace expansion etc.

```bash
filename="report.tar.gz"

echo "${filename#*.}"    # tar.gz   — strips up to the *first* dot
echo "${filename##*.}"   # gz       — strips up to the *last* dot
```

Useful idioms:

```bash
# get everything after the first slash:
path="/etc/nginx/conf.d/site.conf"
echo "${path#*/}"     # etc/nginx/conf.d/site.conf

# get the basename (everything after the last slash):
echo "${path##*/}"    # site.conf

# strip a known prefix:
v="v1.2.3"
echo "${v#v}"         # 1.2.3
```

Things to remember:

- These are *globs*, so `.` is literal, `*` matches any sequence, `?` matches one character.
- If the pattern doesn't match, the variable comes back unchanged.
- Pair these with their sibling, suffix removal `%` and `%%` (next level).
- Combine with replacement `${var/old/new}` for full string surgery without `sed`.
