# Walkthrough: Parse key=value Files

## The plan
Read the file line by line, split each line at the first `=`, and remember the
value of the key we want. Because later assignments override earlier ones, we
keep going to the end of the file and report the last match.

## Step by step
1. Split a line without external tools. `read` splits its input into the variables
   you name, using the characters in `IFS`. Setting `IFS='='` only for the `read`
   command (a prefix assignment) makes the equals sign the separator:

   ```bash
   IFS='=' read -r key value
   ```

2. The key insight is the last variable. When there are more fields than
   variables, the final variable receives the rest of the line, with its
   separators intact. So `url=postgres://x?a=1&b=2` gives `key=url` and
   `value=postgres://x?a=1&b=2`. `cut -d= -f2` would have cut the value short.

3. Use `-r` so backslashes in values are kept literally.

4. Walk the whole file in a `while` loop that reads from `"$file"`. When
   `$key` equals the wanted key, store the value and set the `found` flag, but
   do not stop: if the key appears again, the later value must win.

5. Handle the last line. If the file does not end with a newline, `read`
   returns failure for that line even though `key` and `value` were filled in,
   so a plain `while read` would skip it. Add `|| [[ -n $key ]]` to the loop
   condition.

6. After the loop, print the value and exit 0, or print the error to
   standard error and exit 1.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
file=$1 wanted=$2
found=0 value=
while IFS='=' read -r key value || [[ -n $key ]]; do
  if [[ $key == "$wanted" ]]; then found=1; result=$value; fi
done < "$file"
if (( found )); then printf '%s\n' "$result"; else echo "key not found: $wanted" >&2; exit 1; fi
```

## Try it by hand
```bash
printf 'a=1\nb=x=y\n' > t.conf
./solution.sh t.conf b            # x=y
./solution.sh t.conf zzz; echo $? # key not found: zzz, then 1
IFS=: read -r u p <<< "root:x:0"; echo "$u $p"
```

## Alternative
`grep "^$key=" file | tail -n 1 | cut -d= -f2-` also works, but a key containing
regex characters changes its meaning, and it starts three processes. The `read`
loop uses none and treats the key as plain text.
