# Walkthrough: Symlink Checks

## The plan
Add two refusals in front of the write: one for a link at the file, one for a link
as the containing folder. Everything else stays.

## The attack
Anyone who can create files in a shared folder can create a symlink there. The
script opens `notes/halibut.txt` for appending; the kernel follows the link and
appends to `billing/prices.txt`, using the script's permissions, not the
attacker's. A *dangling* link is worse in a way: `>>` creates the missing
target, so the attacker can make new files in folders they cannot write to.

## Steps
1. Keep the usage check.
2. Work out the folder: `folder=$(dirname -- "$file")`. For a bare `a.txt`
   dirname prints `.`, which is never a link, so that case is safe.
3. `[[ -L $file ]]` is true for any symlink and never follows it. Print the
   refusal and exit before writing.
4. `[[ -L $folder ]]` repeats the test for the folder part.
5. Write with `printf '%s\n' "$text" >> "$file"` so TEXT such as `-n` or `50%s`
   is plain data.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh FILE TEXT" >&2
  exit 2
fi
file=$1
text=$2
folder=$(dirname -- "$file")
if [[ -L $file ]]; then
  printf 'refusing: %s is a symlink\n' "$file" >&2
  exit 1
fi
if [[ -L $folder ]]; then
  printf 'refusing: %s is a symlink\n' "$folder" >&2
  exit 1
fi
printf '%s\n' "$text" >> "$file"
printf 'noted: %s\n' "$file"
```

## Try it
```
mkdir -p notes; echo x > target.txt; ln -s ../target.txt notes/bad.txt
./solution.sh notes/bad.txt hello
```

## Alternative
Resolve the real path (`cd` into the folder, `pwd -P`) and compare it with the
folder you expect, as in the deletion guard. That catches links higher up the
path too. It is stronger but heavier; the `-L` checks cover the two spots an
attacker in a shared folder can reach directly.
