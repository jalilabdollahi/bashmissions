# Walkthrough: Both Streams, One File

## The plan

Run the tool with both of its channels pointing at `cert.log`, then report how
many lines ended up there.

## Step by step

Two ways to say "both" exist. The compact Bash one is `&>`:

```bash
cert-check "$domain" &> cert.log
```

It is the same as `> cert.log 2>&1`, which you will meet in the next level.
`&>` truncates the file first, so any older log is replaced, as asked.

Because the file is opened only once and both descriptors share it, the
warning appears exactly between "checking" and "done", where the tool printed
it. Two separate redirections to the same file name would each open the file
on their own and overwrite one another. That is the classic bug `&>` avoids.

To print the summary, count the lines. On macOS `wc -l` pads the number with
spaces; wrapping it in `$(( ))` turns it into a clean integer:

```bash
lines=$(( $(wc -l < cert.log) ))
echo "saved $lines lines"
```

## The complete solution

```bash
#!/usr/bin/env bash
domain=$1
cert-check "$domain" &> cert.log
lines=$(( $(wc -l < cert.log) ))
echo "saved $lines lines"
```

## Trying it by hand

```bash
./solution.sh northpier.old
cat cert.log
```

## An alternative

`cert-check "$domain" > cert.log 2>&1` works in every POSIX shell, including
`dash`. `&>` is Bash-only, which is fine here because the script starts with
`#!/usr/bin/env bash`.
