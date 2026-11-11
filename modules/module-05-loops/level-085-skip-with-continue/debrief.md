# Debrief: Skip with continue

`break` ends a loop; `continue` ends only the current round. Together they give you full control over the flow without any extra variables.

## How it works
When Bash meets `continue`, it jumps to the next iteration. In a `for` loop that means taking the next word from the list; in a `while` loop it means checking the condition again; in a C-style loop it runs the update part first. Everything below `continue` in the body is not executed for that round.

This enables the "guard clause" style: put the exceptions at the top, each one as a small `if ...; then continue; fi`, and write the normal case below with no nesting. It reads like a checklist: not a test account, not already billed, not suspended, now do the work.

The glob match in `[[ ]]` anchors to the whole value. `TEST-*` means the value must start with `TEST-`. If you need "contains", surround the word with stars on both sides: `*TEST*`.

## In real work
Skipping comments and blank lines in a config, ignoring hidden files, passing over servers that are in maintenance, leaving out accounts that must not be touched.

## Going further
The loop here was fed from `"$@"`. The next level looks at that carefully, because arguments with spaces are where many scripts break.
