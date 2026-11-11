# Walkthrough: Escapes with printf

## The plan
A table row is: a word, a tab, a word, a line break. We need three rows, so we describe all of them in one `printf` text and let the escape codes do the formatting.

## Step by step
1. Know the two codes. `\t` stands for a tab character, `\n` stands for a new line.
2. Write the header row: `SERVER\tSTATUS\n`.
3. Add the two data rows the same way.
4. Wrap the whole thing in single quotes so Bash does not touch the backslashes, then give it to `printf`.

## Complete solution

```bash
#!/usr/bin/env bash
printf 'SERVER\tSTATUS\nanchovy\tup\nbarracuda\tdown\n'
```

## Trying it by hand
Run `bash solution.sh | cat -A`. On Linux this shows tabs as `^I` and line ends as `$`. On macOS use `cat -et`. It is a nice way to prove that the gaps are tabs.

## An alternative
`echo -e` also understands these escapes in Bash, but its behaviour differs between shells and systems, and it is easy to get wrong. `printf` behaves the same everywhere, which is why professionals prefer it for anything beyond a plain line.
