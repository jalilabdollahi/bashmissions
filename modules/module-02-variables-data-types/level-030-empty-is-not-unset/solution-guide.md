# Walkthrough: Empty Is Not Unset

## The plan
Two settings, two policies. For `NOTE`, "empty" is a valid, intentional answer. For `CONTACT`, empty is as bad as missing. The only difference in the code is one colon.

## Step by step
Remember the three states of a variable: unset, set but empty, set with a value. The two fallback forms differ in which states they replace:

| form | unset | empty | value |
|---|---|---|---|
| `${var-x}` | x | (empty) | value |
| `${var:-x}` | x | x | value |

For `NOTE` we want the first row:

```bash
echo "note=[${NOTE-(no note on file)}]"
```

Brackets around the value make an empty result visible, `note=[]`, instead of a trailing space you cannot see. The parentheses inside the default are plain text.

For `CONTACT` we want the second row:

```bash
echo "contact=[${CONTACT:-support@lanternfish.example}]"
```

## Complete solution
```bash
#!/usr/bin/env bash
echo "note=[${NOTE-(no note on file)}]"
echo "contact=[${CONTACT:-support@lanternfish.example}]"
```

## Try it by hand
```
./solution.sh
NOTE= CONTACT= ./solution.sh
NOTE="call after 5pm" ./solution.sh
```
Compare the first two outputs line by line - the only difference is how each line reacts to an empty value.

## Alternative
You could detect the state with `${NOTE+set}` from the unset level and branch on it. That is more code for the same result. The no-colon form exists precisely for "fallback only if never given".
