# Walkthrough: Anchors

## The plan
Each line gets exactly one label. The labels are decided by *where* a piece of
text sits, so the pattern needs anchors. An `if / elif / else` chain makes the
first rule that fits win.

## The three anchored patterns
| rule | regex | reading it |
|---|---|---|
| blank | `^$` | start of line, then immediately the end |
| comment | `^#` | the first character is `#` |
| risky | `\ yes$` | a space, `yes`, and then the end of the line |

Without `^`, any line with a `#` somewhere (`Banner /etc/issue # note`) would
count as a comment. Without `$`, `PermitRootLogin yesterday` would count as
risky because "yes" is inside it.

## Order matters
`#PermitRootLogin yes` satisfies both the comment rule and the risky rule.
Checking comments first gives the label the audit wants.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ ^$ ]]; then
    echo blank
  elif [[ $line =~ ^# ]]; then
    echo comment
  elif [[ $line =~ \ yes$ ]]; then
    echo risky
  else
    echo other
  fi
done
```

## Try it by hand
```bash
printf '# note\n\nPermitRootLogin yes\nPort 22\n' | ./solution.sh
```

## Alternative
`[[ -z $line ]]` is the natural test for an empty line, and `[[ $line == \#* ]]`
tests for a leading `#` with a glob. They work, but `^` and `$` are the same
tools you will reuse in `grep` and `sed`, where there is no `-z` or glob.
