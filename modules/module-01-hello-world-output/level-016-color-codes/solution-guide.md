# Walkthrough: Color Codes

## The plan
The terminal watches the text for sequences that begin with the Escape character (ASCII 27). The sequence `ESC [ 32 m` means "from now on print in green", `ESC [ 0 m` means "back to the defaults". The player's job is to place those sequences around the status words.

## Step by step
1. In printf, the Escape character is written `\033` (octal for 27). `\e` and `\x1b` also work in Bash.
2. Green OK: `\033[32mOK\033[0m`. Everything between the two codes is green; the reset prevents the colour from bleeding into the rest of the line.
3. Do the same for WARN with 33 and FAIL with 31.
4. The sentence after the reset has a `%s` for the service name, which is filled from `"$SERVICE"`.

## Complete solution

```bash
#!/usr/bin/env bash
printf '\033[32mOK\033[0m %s responds in time\n' "$SERVICE"
printf '\033[33mWARN\033[0m %s responds slowly\n' "$SERVICE"
printf '\033[31mFAIL\033[0m %s does not respond\n' "$SERVICE"
```

## Trying it by hand
Run `SERVICE=dory bash solution.sh` in a normal terminal and enjoy the colours. Pipe it through `cat -v` to see the escape characters as `^[`.

## An alternative
`tput setaf 2` asks the terminal database for the right code. It adapts to unusual terminals but needs an extra program and a real terminal. Writing the ANSI codes directly is shorter, and every modern terminal understands them.
