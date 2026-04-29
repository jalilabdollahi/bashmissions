# Remove Suffix

Mirror of `${var#pattern}` but operating on the **end** of the string.

| Form              | Removes from the end...                           |
|-------------------|---------------------------------------------------|
| `${var%pattern}`  | shortest match of `pattern`                       |
| `${var%%pattern}` | longest match of `pattern`                        |

Pattern is again a **glob**, not a regex.

```bash
filename="archive.tar.gz"

echo "${filename%.*}"    # archive.tar   — strips the last extension
echo "${filename%%.*}"   # archive       — strips everything from the first dot

path="/var/log/syslog.1"
echo "${path%.*}"        # /var/log/syslog
echo "${path%/*}"        # /var/log      — strips the last segment

# strip a known suffix:
log="error.log"
echo "${log%.log}"       # error
```

Idiom: combine prefix and suffix removal to extract a middle slice without `sed`:

```bash
url="https://example.com/path/to/file.txt?query=1"
host="${url#*://}"        # example.com/path/to/file.txt?query=1
host="${host%%/*}"        # example.com
```

When the pattern doesn't match, the original value comes back. That's a feature, not a bug — it lets you write `${name%.bak}` and have it be a no-op for files that don't end in `.bak`.
