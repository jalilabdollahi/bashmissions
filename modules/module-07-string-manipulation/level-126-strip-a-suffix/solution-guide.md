# Walkthrough: Strip a Suffix

## The plan
Describe the unwanted tail as "a dot followed by anything" and have Bash remove
the shortest tail that matches.

## Reading the pattern
`.*` is a glob: a literal dot, then any run of characters. Tried from the right
end of `archive.tar.gz`, the possible matches are `.gz` and `.tar.gz`. The single
`%` operator takes the **shortest** one:

```bash
file=$1
echo "${file%.*}"
```

Result: `archive.tar`. That is exactly what you want, because the `.tar` part is
still needed to unpack the file afterwards.

| value | `${v%.*}` |
|---|---|
| `db-2024.sql.gz` | `db-2024.sql` |
| `report.final.v2.pdf` | `report.final.v2` |
| `README` | `README` (no dot, no match) |

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
file=$1
echo "${file%.*}"
```

## Try it by hand
```bash
./solution.sh db-2024.sql.gz
./solution.sh "Q3 summary.v1.xlsx"
./solution.sh README
```

## Alternative
`${file%.gz}` removes a known literal suffix and leaves everything else alone,
which is safer when you only expect `.gz` files. The `.*` form is for "whatever
the last extension is". Avoid `echo "$file" | sed 's/\.[^.]*$//'`: it spawns
processes and needs a regular expression to say what a single `%` says in two
characters.
