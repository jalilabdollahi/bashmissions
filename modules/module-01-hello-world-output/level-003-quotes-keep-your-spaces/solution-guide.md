# Walkthrough: Quotes Keep Your Spaces

## The plan
When you type a command, Bash first cuts the line into words wherever it sees spaces. Extra spaces between words are simply discarded. Our sign needs those extra spaces, so we must stop Bash from splitting. Double quotes do exactly that.

## Step by step
1. See the problem. The starter runs `echo GULL AND ANCHOR`. Bash passes three separate words to echo, and echo joins them with one space each.
2. Even if you type wider gaps without quotes, the result is the same, because the gaps are thrown away before echo sees them.
3. Put the sign in double quotes. Now Bash passes one single word, including the gaps.

## Complete solution

```bash
#!/usr/bin/env bash
echo "GULL   AND   ANCHOR"
```

## Trying it by hand
Run these two lines in your terminal and compare the output:

```
echo GULL   AND   ANCHOR
echo "GULL   AND   ANCHOR"
```

## An alternative
Single quotes would also keep the spaces here. You meet the difference between the two kinds of quotes in the next level. For plain text either works, but double quotes are the usual habit.
