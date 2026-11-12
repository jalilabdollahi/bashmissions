# Walkthrough: Check the Status

## The plan
Run `grep` for the exact line, but do not look at what it prints. Quiet mode
(`-q`) makes it print nothing; its answer comes back as the exit status, and
`$?` is where Bash keeps that answer.

## Step by step
1. Run the search. `-x` means the whole line must match, so `maintenance=online`
   and `# maintenance=on` do not count. `2>/dev/null` hides grep's complaint
   when the file does not exist, because we will write our own message.

   ```bash
   grep -qx 'maintenance=on' "$file" 2>/dev/null
   ```

2. Save the status immediately. `$?` always describes the *latest* command, so
   even a harmless `echo` between the two lines would replace it.

   ```bash
   status=$?
   ```

3. Decide. grep's contract: 0 means a match, 1 means no match, 2 or more means
   an error. A `case` handles the three outcomes cleanly.

## Complete solution
```bash
#!/usr/bin/env bash
file=$1
grep -qx 'maintenance=on' "$file" 2>/dev/null
status=$?
case $status in
  0) echo "maintenance: ON" ;;
  1) echo "maintenance: off" ;;
  *) echo "cannot read $file (grep status $status)" >&2; exit 2 ;;
esac
```

## Try it by hand
```bash
printf 'maintenance=on\n' > a.status
./solution.sh a.status        # maintenance: ON
./solution.sh nothing.status  # cannot read nothing.status (grep status 2)
echo $?                       # 2
```
Type `grep -q x /nonexistent; echo $?` at the prompt to watch a status appear.

## Alternative
`if grep -qx 'maintenance=on' "$file"; then ... else ... fi` is shorter, but it
squashes "not found" and "file unreadable" into the same else branch. Reading
`$?` is how you keep them apart.
