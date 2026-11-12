# Walkthrough: Two Lines of Output

## The plan
The note has three lines. Every `echo` prints its text and then moves to a new line, so three `echo` commands give three lines. Bash executes the script strictly from top to bottom, so the order you write them is the order they appear.

## Step by step
1. Start from the shebang and the first `echo "HANDOVER NOTE"` that the starter gives you.
2. Add the pager line underneath.
3. Add the coffee line underneath that.

## Complete solution

```bash
#!/usr/bin/env bash
echo "HANDOVER NOTE"
echo "Pager: Ollie"
echo "Coffee: refilled"
```

## Trying it by hand
Run `bash solution.sh` in the workspace. Then experiment: swap two of the echo lines and run it again. The output order flips with them, which is the whole lesson of this level.

## An alternative
You could pack everything into one command with a trick for line breaks, but that needs escapes you learn in level 5. Separate `echo` lines are easier to read and to change later, so they are the better choice for now.
