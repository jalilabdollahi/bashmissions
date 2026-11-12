# Walkthrough: Loop over a List

## The plan
You have five names and one sentence to print for each. Instead of repeating the sentence five times, you describe it once and tell Bash which names to feed it.

## Step by step
1. Start the loop and give the list: `for name in anchovy barracuda cuttlefish dory eel; do`. The word after `for` is a variable of your choice. Bash sets it to the first name, runs the body, then sets it to the second name, and so on.
2. Write the body, using the variable like any other: `echo "refreshing banner on $name"`.
3. Close the loop with `done`.
4. The final line goes after `done`. Anything placed there runs once, when every round is finished.

## Complete solution

```bash
#!/usr/bin/env bash
for name in anchovy barracuda cuttlefish dory eel; do
  echo "refreshing banner on $name"
done
echo "all banners refreshed"
```

## Trying it by hand
Run `bash solution.sh` and count the lines: five banner lines and one closing line. Then add a sixth name, `flounder`, to the list and run again. You changed one word and got one more line; that is the whole point of a loop.

## An alternative
You can put the words on separate lines with a backslash, or store them in a variable first (`servers="anchovy dory"; for s in $servers`). The literal list is the clearest for a short, fixed set of names. Later levels loop over arguments, files and command output instead.
