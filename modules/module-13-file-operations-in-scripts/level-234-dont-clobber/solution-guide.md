# Walkthrough: Don't Clobber

## The plan

Plain `>` truncates its target without asking. "Clobber" is the shell's word
for that. We switch protection on, let the safe path be the default, and give
the dangerous path an explicit, visible spelling.

## Step by step

Check the arguments, then name them; the third one is optional, so give it a
default of empty so `set -u` does not complain:

```bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh FILE TEXT [--force]" >&2
  exit 2
fi
file=$1; text=$2; force=${3:-}
```

Now the protection:

```bash
set -o noclobber
```

From this line on, `echo hi > existing.txt` fails with "cannot overwrite
existing file" and the file stays as it was. New files are created normally.

The deliberate overwrite uses `>|`:

```bash
echo "$text" >| "$file"
```

For the refusal path we want our own message, not the shell's. The shell
prints its complaint while it sets up the redirection, so we must silence a
whole group, not just `echo`:

```bash
if ! { echo "$text" > "$file"; } 2>/dev/null; then
  echo "refusing to overwrite $file" >&2
  exit 1
fi
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then echo "usage: solution.sh FILE TEXT [--force]" >&2; exit 2; fi
file=$1; text=$2; force=${3:-}
set -o noclobber
if [[ $force == --force ]]; then
  echo "$text" >| "$file"
elif ! { echo "$text" > "$file"; } 2>/dev/null; then
  echo "refusing to overwrite $file" >&2
  exit 1
fi
echo "wrote $file"
```

## Try it by hand

```bash
./solution.sh demo.txt one
./solution.sh demo.txt two ; echo "exit $?"
./solution.sh demo.txt two --force ; cat demo.txt
```

## An alternative

`[[ -e $file ]]` before writing gives the same refusal, but there is a tiny
window between the check and the write in which another process can create
the file. With noclobber the shell opens the file with "create, fail if
present", a single atomic step.
