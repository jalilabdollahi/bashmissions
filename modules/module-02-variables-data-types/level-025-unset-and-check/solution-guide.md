# Walkthrough: Unset and Check

## The plan
Ask "does TOKEN exist?" once, delete it, then ask again. The report format avoids any if-statement: the answer is printed inside square brackets, so "no" simply leaves the brackets empty.

## Step by step
The expansion `${TOKEN+set}` reads as: "if TOKEN exists, use the word set; otherwise use nothing". Note the plus sign without a colon: the test is for existence only, not for content.

```bash
echo "before=[${TOKEN+set}]"
```

Try the three situations in your terminal:

```
TOKEN=abc bash solution.sh   # before=[set]
TOKEN=   bash solution.sh    # before=[set]  (empty, but it exists)
bash solution.sh             # before=[]
```

The middle case is the one people get wrong with `[ -n "$TOKEN" ]` style checks.

Now delete the variable:

```bash
unset TOKEN
```

After this, `TOKEN` is not merely empty - it does not exist. The same expansion proves it:

```bash
echo "after=[${TOKEN+set}]"
```

## Complete solution
```bash
#!/usr/bin/env bash
echo "before=[${TOKEN+set}]"
unset TOKEN
echo "after=[${TOKEN+set}]"
```

## Try it by hand
Run it with the three setups above. The last line is always `after=[]`.

## Alternative
`TOKEN=` (assign nothing) makes the *value* empty but the variable still exists, so `${TOKEN+set}` would still say `set`. Only `unset` makes the variable vanish, which is why this level uses it.
