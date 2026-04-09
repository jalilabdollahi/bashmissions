# Bash Guide

This guide is the beginner-friendly reference for BashMissions.

It is here to answer the questions that many early levels assume you are still learning:

- What is Bash?
- What does a shell script do?
- What are `$1`, `$2`, and `"$@"`?
- How do strings, variables, conditions, loops, and functions work?
- Why does quoting matter so much?

If a level feels confusing, come back here. You do not need to memorize everything at once.

## What Bash Is

Bash is a shell and a scripting language.

When you type commands in a terminal, Bash can run them one at a time. A Bash script is just a text file containing terminal commands and simple programming logic so the computer can repeat tasks for you.

Example:

```bash
#!/usr/bin/env bash
echo "Hello"
echo "World"
```

If that file is called `solution.sh`, Bash runs the lines from top to bottom.

## The First Line: Shebang

Many scripts start like this:

```bash
#!/usr/bin/env bash
```

This tells the system to run the file with Bash.

You will also often see:

```bash
set -euo pipefail
```

This makes scripts safer:

- `-e`: stop when a command fails
- `-u`: error on undefined variables
- `pipefail`: fail a pipeline if part of it fails

For learning, this is useful because mistakes appear earlier and more clearly.

## Running a Script

Suppose you have:

```bash
#!/usr/bin/env bash
echo "Hello from Bash"
```

You can run it with:

```bash
bash solution.sh
```

Or make it executable and run:

```bash
chmod +x solution.sh
./solution.sh
```

## Arguments and Parameters

When a script is run with extra words after its name, those are arguments.

Example:

```bash
./solution.sh apple banana
```

Inside the script:

- `$1` is `apple`
- `$2` is `banana`
- `$3` is the third argument
- `$#` is the number of arguments
- `"$@"` means all arguments, safely quoted

Example:

```bash
#!/usr/bin/env bash
echo "First: $1"
echo "Second: $2"
echo "Count: $#"
```

## Why Quoting Matters

Quoting is one of the biggest Bash basics.

Use quotes around variables unless you have a very specific reason not to.

Good:

```bash
echo "$1"
cp "$source" "$target"
```

Risky:

```bash
echo $1
cp $source $target
```

Without quotes, spaces can break your input into multiple pieces.

Example:

```bash
name="Ada Lovelace"
echo "$name"
```

This prints one value: `Ada Lovelace`

## Variables

Set a variable like this:

```bash
name="Fatemeh"
```

Use it like this:

```bash
echo "$name"
```

Important:

- No spaces around `=`
- Variable names are usually letters, numbers, and `_`

Good:

```bash
count=3
user_name="sam"
```

Bad:

```bash
count = 3
```

## Strings

Strings are just text values.

Examples:

```bash
message="hello"
echo "$message"
```

Single quotes and double quotes are different:

```bash
name="Ada"
echo '$name'
echo "$name"
```

Output:

```text
$name
Ada
```

Single quotes keep the text literal. Double quotes allow variable expansion.

## Command Substitution

You can store command output in a variable:

```bash
today=$(date +%Y-%m-%d)
echo "$today"
```

This runs `date +%Y-%m-%d` and stores the result.

## Exit Codes

Commands return an exit status:

- `0` usually means success
- non-zero usually means failure

You can set a script exit code:

```bash
exit 0
exit 1
```

Many BashMissions levels check both output and exit status.

## Conditions

An `if` statement lets your script choose what to do.

Example:

```bash
#!/usr/bin/env bash

if [ -f "$1" ]; then
  echo "file exists"
else
  echo "missing"
  exit 1
fi
```

Common tests:

- `[ -f "$path" ]` file exists
- `[ -d "$path" ]` directory exists
- `[ "$a" = "$b" ]` strings equal
- `[ "$a" != "$b" ]` strings not equal
- `[ -n "$value" ]` string not empty
- `[ -z "$value" ]` string is empty

## Loops

Loops repeat work.

### For loop

```bash
for item in one two three; do
  echo "$item"
done
```

### While loop

```bash
count=1
while [ "$count" -le 3 ]; do
  echo "$count"
  count=$((count + 1))
done
```

## Arithmetic

Use arithmetic expansion:

```bash
count=2
next=$((count + 1))
echo "$next"
```

## Reading Input

You can read from the user or from redirected input:

```bash
read -r name
echo "Hello, $name"
```

The `-r` flag is a good default because it avoids surprising backslash behavior.

## Functions

Functions let you reuse logic.

```bash
say_hello() {
  echo "Hello, $1"
}

say_hello "Ada"
```

They make longer scripts easier to organize.

## Files and Paths

Many missions work with files.

Useful commands:

- `cat file.txt` show file contents
- `cp source target` copy a file
- `mv old new` move or rename
- `rm file.txt` remove a file
- `mkdir dir` create a directory

Inside Bash scripts, always think carefully about whether a path exists before using it.

## Redirection

You can send output into files:

```bash
echo "hello" > out.txt
echo "world" >> out.txt
```

- `>` overwrite
- `>>` append

You can read input from a file:

```bash
while read -r line; do
  echo "$line"
done < data.txt
```

## Pipes

A pipe sends output from one command into another:

```bash
cat data.txt | wc -l
```

You will often see cleaner versions like:

```bash
wc -l < data.txt
```

or:

```bash
grep "error" data.txt
```

## Common Beginner Mistakes

### 1. Forgetting quotes

```bash
echo $1
```

Safer:

```bash
echo "$1"
```

### 2. Using spaces in variable assignment

Wrong:

```bash
name = "sam"
```

Correct:

```bash
name="sam"
```

### 3. Printing almost the right output

BashMissions often checks exact output. Even a missing colon, extra space, or extra line can fail a level.

### 4. Forgetting exit codes

Some levels want success for one path and `exit 1` for another.

### 5. Solving only one test case

If the level mentions optional arguments or missing files, your script must handle those too.

## A Good Problem-Solving Routine

When a level feels hard, use this order:

1. Read the mission carefully.
2. Identify the inputs.
3. Identify the exact required output.
4. Identify the required exit code.
5. Write the smallest script that handles the happy path.
6. Add the failure path or edge cases.
7. Run `check`.
8. If stuck, use `hint`.
9. If still stuck, use `guide`.
10. If completely blocked, use `answer`, then study why it works.

## Suggested Mental Model

A Bash script usually does four things:

1. Read input
2. Make a decision
3. Run commands
4. Print output and exit with the right status

If you keep asking those four questions, most early BashMissions levels become much easier to reason about.

## Final Advice

You do not need to “feel ready” before moving forward.

Bash gets easier by repetition:

- read the mission
- write a tiny script
- run the check
- fix one mistake at a time

That is the whole game.
