# Walkthrough: Exit Codes Speak

## The plan
The monitoring wall does not read text, it reads a number. So the script must print its message and then finish with status 2. Because `exit` stops the script, the line that follows it is never executed.

## Step by step
1. Run the starter: `bash solution.sh; echo $?`. It prints two lines and the status is 0, because the last command succeeded. Not what the wall needs.
2. Put `exit 2` immediately after the CRITICAL message.
3. Run the same command again. You should see only the CRITICAL line and the number 2. The special variable `$?` holds the exit status of the last command that ran, here the script itself.

## Complete solution

```bash
#!/usr/bin/env bash
echo "CRITICAL: order queue is backed up"
exit 2
```

## Trying it by hand
`bash solution.sh; echo "status was $?"` should print the message and then `status was 2`.

## An alternative
You can let the script reach the end and finish with a failing command, but then the status is whatever that command returned, which hides your intention. An explicit `exit N` states the code on purpose and is much easier to audit.
