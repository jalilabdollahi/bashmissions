# Walkthrough: Replace Every Match

## The plan
Two passes over the same variable: first spaces, then slashes. After each pass,
the new text is stored back so the next pass sees it.

## Replace all
The single-slash form stops at the first match. Add a second slash after the
variable name and Bash keeps going to the end of the value:

```bash
name=${name// /_}
```

Read it as: in `name`, replace (`//`) every space (` `) with `_`. The space between
the two slashes is the search text, so be careful not to delete it.

## The slash problem
In `${name//X/Y}` the slashes are separators, so searching for a slash needs an
escape, otherwise Bash cannot tell where the search text ends:

```bash
name=${name//\//-}
```

Here `\/` is the search text (one literal slash) and `-` is the replacement.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
name=$1
name=${name// /_}
name=${name//\//-}
echo "$name"
```

## Try it by hand
```bash
./solution.sh "Tidewater Books / Q3 report.pdf"
./solution.sh "2024/11/07/invoice.pdf"
```
Expected: `Tidewater_Books_-_Q3_report.pdf` and `2024-11-07-invoice.pdf`.

## Alternative
`tr ' /' '_-'` does both in one go for single characters. The expansion is the
better choice in a script because it handles multi-character search text too
(`${name//.tar.gz/}`), starts no process, and cannot be confused by a name that
begins with a dash.
