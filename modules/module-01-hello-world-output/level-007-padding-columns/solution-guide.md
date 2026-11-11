# Walkthrough: Padding Columns

## The plan
Every printf placeholder can carry a width. A width reserves that many characters for the value and fills unused space with blanks. A minus sign flips the alignment from the default right to left.

## Step by step
1. Decide the box sizes. The host name gets 10 characters, left-aligned: `%-10s`. The count gets 5, right-aligned: `%5d`.
2. Surround each box with brackets in the format so you can see where the boxes end. Brackets are just literal text in the format.
3. The header is text too, so use `%s` with the same widths: `[%-10s] [%5s]`.
4. Feed it the values. The header values are literal words, the row values are `"$HOST"` and `"$USERS"`.

## Complete solution

```bash
#!/usr/bin/env bash
printf '[%-10s] [%5s]\n' "HOST" "USERS"
printf '[%-10s] [%5d]\n' "$HOST" "$USERS"
```

## Trying it by hand
`HOST=dory USERS=42 bash solution.sh` should print the padded rows. Try a name longer than 10 characters: the box does not truncate, it simply grows.

## An alternative
You could count spaces by hand with echo and type the padding yourself. That breaks the moment a value changes length, which is precisely why widths exist.
