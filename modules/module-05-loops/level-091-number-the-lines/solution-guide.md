# Walkthrough: Number the Lines

## The plan
A plain list loop gives you the current name but not its position. Here the position is the important thing: position 0 is Monday, position 7 is Monday again. So you loop over positions and look the name up by position.

## Step by step
1. Store the day names in an array: `days=(Mon Tue Wed Thu Fri Sat Sun)`. Arrays count from 0, so `${days[0]}` is `Mon`.
2. Copy the arguments into an array too: `people=("$@")`. The quotes keep "Ollie Park" as one element. The number of people is `${#people[@]}`.
3. Count the positions with a C-style loop: `for (( i = 0; i < ${#people[@]}; i++ ))`. With no arguments the count is 0 and the loop does not run.
4. Work out the day for position `i`: `i % ${#days[@]}`. The `%` operator is the remainder after division. For `i` from 0 to 6 it returns `i`; for 7 it returns 0 again; for 8 it returns 1. That is the wrap-around.
5. Print the day and the person: `echo "$day: ${people[i]}"`. Inside `[ ]` of an array index Bash evaluates arithmetic, so you can write `i` without a dollar sign.

## Complete solution

```bash
#!/usr/bin/env bash
days=(Mon Tue Wed Thu Fri Sat Sun)
people=("$@")
for (( i = 0; i < ${#people[@]}; i++ )); do
  day=${days[ i % ${#days[@]} ]}
  echo "$day: ${people[i]}"
done
```

## Trying it by hand
`bash solution.sh a b c d e f g h` (eight names) shows the wrap on the last line. Try printing `$i` as well to watch the index.

## An alternative
Keep a second counter in a `for name in "$@"` loop (`i=$(( i + 1 ))`). It works, but then you maintain the counter by hand, and a `continue` that skips the increment would throw the positions off. Indexing arrays directly makes the position part of the loop.
