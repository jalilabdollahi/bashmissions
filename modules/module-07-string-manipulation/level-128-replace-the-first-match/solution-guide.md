# Walkthrough: Replace the First Match

## The plan
Name the three arguments and apply one substitution to the list.

## The expansion
`${list/old/new}` looks for the first match of `old` inside `$list` and swaps it
for `new`. Everything else is left alone, including further matches:

```bash
list="eel:5432,eel:5433"
echo "${list/eel/marlin}"      # marlin:5432,eel:5433
```

Because the search text comes from a variable, there is one more detail. The
text between the first and second slash is a *pattern*. If the host name were
`db[1]` or `a*b`, the brackets and star would act as wildcards and the wrong
text could be replaced. Quoting the variable makes Bash take it literally:

```bash
echo "${list/"$old"/$new}"
```

The replacement part is never a pattern, so it needs no such treatment. If there
is no match, the value comes back unchanged.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
list=$1
old=$2
new=$3
echo "${list/"$old"/$new}"
```

## Try it by hand
```bash
./solution.sh "eel:5432,eel:5433" eel marlin
./solution.sh "db[1]:1,db[1]:2" "db[1]" primary
```

## Alternative
`sed "s/$old/$new/"` also replaces the first match per line, but the search text
is a regular expression, so special characters bite, and a slash inside `$old`
breaks the command. The expansion works with the string as plain data and costs no
process.
