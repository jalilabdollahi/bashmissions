# Walkthrough: Terminal Status Board

## The plan
A table only looks tidy if every column is as wide as its widest cell, and you
cannot know that until you have seen all the rows. So the script makes two
passes over the data: the first reads and measures, the second prints.

## Step by step
1. **Collect.** For each stdin line, split it into an array with
   `read -r -a f <<< "$line"` and count the fields with `${#f[@]}`. Lines that
   do not have exactly four fields go to stderr and are skipped. Valid ones go
   into four parallel arrays, and two width variables grow when a longer value
   shows up (`${#f[0]}` is a string's length), starting from the width of the
   words HOST and STATE:

   ```bash
   (( ${#f[0]} > width )) && width=${#f[0]}
   ```

2. **Guard.** If no host survived, say so on stderr and exit 1. An empty board
   would look like a healthy fleet.

3. **Header and rule.** printf's `*` takes a width from an argument, `-` makes
   it left-aligned:

   ```bash
   printf '%-*s  %-*s  %5s  %5s\n' "$width" HOST "$swidth" STATE LOAD DISK
   ```

   For the line of dashes, print spaces into a variable with `printf -v rule
   '%*s' N ''` and swap each space for `-` with `${rule// /-}`.

4. **Rows.** Build each row into a variable with `printf -v row`, add the
   markers with `row+=`, and print the finished row once. Building first keeps
   trailing spaces out of unmarked rows.

5. **Summary.** The counts were collected as the rows were processed.

## Try it by hand
```
printf 'eel up 0.42 31%%\nhumpback-staging down 0.00 95%%\n' | ./solution.sh
```

## Alternative
The `column -t` command aligns text automatically, but it is not installed
everywhere, and it cannot right-align or add markers. Controlling the layout
with printf works on every system.
