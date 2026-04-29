# Use a Variable

Bash has two equivalent forms for reading a variable:

| Form         | Example              | When to use                                  |
|--------------|----------------------|----------------------------------------------|
| `$var`       | `echo "$name"`       | The default — fine when followed by punctuation, end of string, or whitespace. |
| `${var}`     | `echo "${name}_x"`   | When the variable name borders other word characters (letters, digits, `_`).   |

Without the braces, Bash uses the **longest valid identifier** that follows `$`. So `$name_suffix` looks for a variable called `name_suffix`, not `name`. With `set -u` enabled, that's a hard error; without it, you silently get an empty string.

```bash
file="report"
echo "$file.pdf"      # report.pdf       — works because `.` ends the name
echo "${file}_v2"     # report_v2        — works
echo "$file_v2"       # (empty)          — looks up unset $file_v2
```

The braces also enable parameter expansion features (`${var:-default}`, `${var^^}`, `${var:1:3}`) covered in later levels.
