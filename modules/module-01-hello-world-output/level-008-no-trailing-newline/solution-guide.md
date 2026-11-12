# Walkthrough: No Trailing Newline

## The plan
We need two commands writing to the same line. The first one must not end the line, the second one finishes it.

## Step by step
1. Run the starter and look at the output. The label and the result sit on separate lines, because `echo` appends a newline.
2. Tell echo not to: `echo -n "Checking backups... "`. The `-n` flag means "no trailing newline".
3. Keep the space at the end of the label inside the quotes, otherwise the result is glued to the dots.
4. The second command is a normal `echo "$RESULT"`, which prints the verdict and ends the line.

## Complete solution

```bash
#!/usr/bin/env bash
echo -n "Checking backups... "
echo "$RESULT"
```

## Trying it by hand
`RESULT=ok bash solution.sh` prints one line. Try it with `printf "Checking backups... "` in place of the first line and compare.

## An alternative
`printf "Checking backups... "` is more portable than `echo -n`: in some shells (and in `sh` on certain systems) `-n` is printed literally. Inside Bash both work, and `echo -n` is the quicker one to read, so it is fine here. The care is worth remembering for scripts that start with `#!/bin/sh`.
