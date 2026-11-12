# Walkthrough: Command Substitution

## The plan
We need text that is partly fixed (`Oldest: `) and partly produced by another command. Command substitution is the bridge: Bash runs the command inside `$( ... )`, captures what it prints, and puts it into the line where the `$( ... )` was.

## Step by step
1. First find the right commands by hand. `head -n 1 fixtures/queue.txt` prints the first ticket, `tail -n 1 fixtures/queue.txt` prints the last one.
2. Put the first inside the oldest line: `echo "Oldest: $(head -n 1 fixtures/queue.txt)"`.
3. Do the same with `tail` for the newest line.
4. The substitution sits inside double quotes. That is intentional: spaces in the ticket text stay together and the commas are safe.

## Complete solution

```bash
#!/usr/bin/env bash
echo "Oldest: $(head -n 1 fixtures/queue.txt)"
echo "Newest: $(tail -n 1 fixtures/queue.txt)"
```

## Trying it by hand
`bash solution.sh` in the workspace. Edit `fixtures/queue.txt` and run again; the answers follow the file.

## An alternative
Older scripts use backticks: `` `head -n 1 file` ``. They do the same job, but they are harder to read and to nest. `$( ... )` is the modern form and the one to write.
