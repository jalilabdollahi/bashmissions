# Walkthrough: Errors to a File

## The plan

`nightly-backup` talks on two channels. The task is to split them: progress to
the screen, warnings to a file. Only descriptor 2 needs redirecting.

## Step by step

Start with the call itself:

```bash
nightly-backup "$site"
```

Run it with `BACKUP_WARNINGS=2` and you will see all lines on the terminal,
and you cannot tell which channel they came from. Now add the redirection:

```bash
nightly-backup "$site" 2> backup-errors.log
```

The `2` in front of `>` names the descriptor. Without a number, `>` means
`1>`. The progress lines still go to descriptor 1, which is still your
terminal. The warnings, descriptor 2, now land in the file.

Because `2>` truncates like `>`, the file is created even if the tool never
writes a warning. That is why the "clean run" test finds an empty file, and
why yesterday's warnings disappear.

## The complete solution

```bash
#!/usr/bin/env bash
site=$1
nightly-backup "$site" 2> backup-errors.log
```

## Trying it by hand

```bash
BACKUP_WARNINGS=2 ./solution.sh harbour-bakery
cat backup-errors.log
```

Two progress lines on the screen, two warnings in the file.

## An alternative

Redirecting stdout to one file and stderr to another
(`cmd > out.log 2> err.log`) is a common pattern, but it is not what Noor
asked for: she needs the progress to remain on screen for the cron mail.
