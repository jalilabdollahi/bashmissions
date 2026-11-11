# Walkthrough: Close and Restore

## The plan

Save the screen, send stdout to the log, run the noisy part, put the screen
back. The finishing message must be visible again.

## Step by step

Think of descriptor 1 as a cable plugged into the terminal. If you simply
re-plug it into the log file, the terminal cable is gone and you cannot find
your way back. So before changing it, make a spare:

```bash
exec 4>&1
```

`4>&1` means "make 4 a copy of wherever 1 points". Both now lead to the
terminal. Now we can re-plug cable 1:

```bash
exec > build.log
```

With `exec` and no command, the change applies to the shell itself. Every
following command, including the plain `echo`, writes to the file. No
per-command redirection is needed, and any child process (`compile-site`)
inherits it.

To restore, copy the spare back and drop it:

```bash
exec 1>&4 4>&-
```

`1>&4` re-points 1 at the screen (because 4 still points there), and `4>&-`
closes the spare so it does not leak into later commands. Redirections are
processed left to right, so the order is safe.

After that, `echo` shows on the terminal again, and `wc -l < build.log` can
count the lines the log holds (arithmetic wrapper for macOS padding).

## The complete solution

See answer.sh.

## Trying it by hand

```bash
./solution.sh harbourbakery
cat build.log
```

Delete the restore line and watch your final message end up in the log (or
nowhere): that is the bug this level prevents.

## An alternative

`{ echo "site=$site"; compile-site "$site"; } > build.log` redirects only the
block and restores automatically. It is cleaner when the noisy part is one
contiguous chunk, and it is the next level. The save-and-restore with `exec`
is for spreading a redirection over a longer stretch, across functions.
