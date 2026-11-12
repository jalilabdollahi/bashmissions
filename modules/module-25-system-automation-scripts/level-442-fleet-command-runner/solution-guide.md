# Walkthrough: Fleet Command Runner

## The plan

Every fleet tool, from a five-line script to Ansible, has the same core: for
each host, run something, record what happened, keep going. The details that
make it safe are about failure, not success.

## Building it

Read the host file with `while IFS= read -r host`, skipping blank lines and
lines that start with `#`. Everything after the host file in the argument
list is the command; `shift` once and use `"$*"` to hand all its words to ssh
as one string.

Two flags matter. `-o BatchMode=yes` means "never prompt": an unattended
script that waits for a password hangs forever. `-n` means "do not read
stdin". Without it, the first `ssh` swallows every remaining line of the host
file, and the script appears to work for exactly one host.

Capture output and status in one expression:
`rc=0; out=$(ssh -n ... "$host" "$*" 2>&1) || rc=$?`. The `|| rc=$?` is what
stops `set -e` from aborting on a failing host.

ssh has a convention worth memorising: exit 255 means ssh itself failed (DNS,
timeout, refused, authentication). Any other status is the remote command's
own. Treat 255 as UNREACHABLE and the rest as a failed command.

Print each output line with the host prefix so a hundred hosts can be
filtered with `grep`. Keep three counters and finish with
`(( failed == 0 ))` as the exit status.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'anchovy\ndory\n' > fleet.txt
./solution.sh fleet.txt uname -r
cat .calls.log
```

## Alternative

`xargs -P` or GNU parallel run hosts concurrently, which is faster but mixes
the output. A sequential loop with a clear prefix is the right first tool.
