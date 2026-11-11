# Walkthrough: Create Exclusively

## The plan
Delete the `-e` test. Turn on noclobber so that writing with `>` can only
*create*, and use the success or failure of that single write to decide who
won.

## The race
Theo's script does: look (`-e`), then act (`>`). In between, another process can
create the file (two engineers, one job) or an attacker can plant a symlink. This
class of bug is called TOCTOU: time of check to time of use. You cannot fix it
by checking harder; you fix it by making the check and the use one operation.

## How noclobber helps
With `set -o noclobber`, Bash opens the target for a plain `>` with the
"create, fail if it exists" flag (O_EXCL). The kernel decides atomically, so
exactly one caller can succeed. That flag also refuses to follow symlinks, which
is why a planted link, dangling or not, is rejected.

## Steps
1. Set the option before the write: `set -o noclobber`.
2. Make the write the condition of an `if`:
   ```bash
   if { printf '%s\n' "$owner" > "$file"; } 2>/dev/null; then
   ```
   The `2>/dev/null` on the braces hides the shell's own error text so you can
   print your message.
3. In the success branch print `claimed: JOB`; in the else branch print the
   failure to stderr and `exit 1`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh JOB OWNER" >&2
  exit 2
fi
job=$1
owner=$2
file="claims/$job.owner"
set -o noclobber
if { printf '%s\n' "$owner" > "$file"; } 2>/dev/null; then
  printf 'claimed: %s\n' "$job"
else
  printf 'claim failed: %s is already taken\n' "$job" >&2
  exit 1
fi
```

## Try it
```
mkdir -p claims
./solution.sh 7 mara
./solution.sh 7 theo; cat claims/7.owner
```

## Alternative
`mkdir claims/7.lock` is also atomic (it fails if the folder exists) and is the
classic lock-file trick when you only need a yes/no. Noclobber is better here
because the winner's name goes into the file in the same step.
