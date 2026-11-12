# Walkthrough: umask for Secrets

## The plan
Make the secret file private at creation time, and keep that restriction from
leaking into the public index file.

## How permissions get chosen
When a program creates a file it asks for a mode (usually 666 for files, 777 for
folders). The kernel then subtracts the process's **umask**. With the common
default of 022 a new file becomes 644: everyone can read it. With 077 it becomes
600: only you.

The "create, then `chmod 600`" habit has a gap between the two commands where
any other user can open the file. A reader who opens it in that gap keeps their
file handle even after the chmod.

## Steps
1. Wrap the secret work in a subshell and set the mask first:
   ```bash
   (
     umask 077
     mkdir -p secrets
     printf '%s\n' "$key" > "secrets/$name.key"
   )
   ```
   `mkdir -p` also benefits: a folder created under this umask is 700.
2. After the subshell ends the umask is back to normal, so
   `printf '%s\n' "$name" >> index.txt` produces an ordinary readable file.
3. Print the confirmation.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh NAME KEY" >&2
  exit 2
fi
name=$1
key=$2
(
  umask 077
  mkdir -p secrets
  printf '%s\n' "$key" > "secrets/$name.key"
)
printf '%s\n' "$name" >> index.txt
printf 'stored: secrets/%s.key\n' "$name"
```

## Try it
```
./solution.sh harbour abc123
ls -l secrets index.txt
```
Look at the first column: `-rw-------` for the key, `-rw-r--r--` for the index.

## Alternative
Set `umask 077` at the top of the script and set it back (`umask 022`) later.
That works but is easy to forget on an early `exit`; the subshell restores the
old value automatically.
