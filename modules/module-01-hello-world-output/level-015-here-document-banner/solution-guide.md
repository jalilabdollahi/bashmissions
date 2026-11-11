# Walkthrough: Here-Document Banner

## The plan
A here-document lets you embed a block of text in the script. `cat` copies its input to the output, so `cat <<EOF` followed by text and a closing `EOF` prints the text. It keeps line breaks, blank lines and indentation, and it expands variables.

## Step by step
1. Start with `cat <<EOF` on its own line. `EOF` is just a label; you choose it, and it must be the same at the end.
2. Type the notice as you want it to appear. Insert `$CUSTOMER` in the greeting and `$WINDOW` after four spaces.
3. Leave empty lines where the notice has empty lines.
4. Close the block with a line containing only `EOF`, starting at the very first column. No spaces before it, no text after it.

## Complete solution

```bash
#!/usr/bin/env bash
cat <<EOF
Dear $CUSTOMER,

We will be doing maintenance on your server during:
    $WINDOW
Your sites may be unavailable for a few minutes.

-- Lanternfish Hosting
EOF
```

## Trying it by hand
`CUSTOMER="Harbour Bakery" WINDOW="Sunday 02:00" bash solution.sh`.

## An alternative
Seven separate `echo` lines would print the same text. But blank lines become `echo ""`, indentation needs quotes and the whole block is harder to read as a letter. A here-document looks like the thing it prints.
