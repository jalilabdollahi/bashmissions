# Walkthrough: Report the Failing Line

## The plan
`set -e` already stops the script on the first failure, but silently. An ERR trap
adds a voice: just before the shell gives up, it runs a handler that can print
where we are and what just failed.

## Step by step
1. Turn on errexit and write the trap before any command that can fail:

   ```bash
   set -e
   trap 'echo "error: line $LINENO: $BASH_COMMAND" >&2' ERR
   ```

2. Understand the two variables. `$LINENO` holds the line number of the command
   being executed and `$BASH_COMMAND` holds its text, exactly as written in the
   script (before variable expansion). When the trap fires, both still describe
   the command that just failed.

3. Mind the quotes. In single quotes the text goes to the trap untouched and
   `$LINENO` is expanded when the trap runs. In double quotes, Bash would
   substitute the current line (the trap line itself) immediately, and every error
   would claim to happen on that line.

4. The handler writes to stderr (`>&2`), so stdout stays clean for real results.

## Complete solution
```bash
#!/usr/bin/env bash
set -e
trap 'echo "error: line $LINENO: $BASH_COMMAND" >&2' ERR
mkdir -p out
cp release/app.tar out/
grep -q ^version= release/app.version
echo "packaged"
```

## Try it by hand
```bash
mkdir -p release; echo version=1 > release/app.version
./solution.sh      # cp fails: error: line 5: cp release/app.tar out/
echo $?            # 1
```

## Alternative
If the handler needs several lines, call a function and pass the line in:
`trap 'on_error $LINENO' ERR`. The `$LINENO` must stay in the trap string,
because inside the function `$LINENO` would point at the function body.
