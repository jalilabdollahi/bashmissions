# Walkthrough: The Blue-Green Switcher

## The plan
Blue-green deployment keeps two complete copies of the application. Users are served by the live one; the idle one is where you install and test the new version. Releasing is then not "copy files over the running site" but "change which copy is live". In this tool, "which copy is live" is a single symlink, `current`, and the whole mission is about changing it correctly.

Correctly means three things. First, **atomically**: the web server resolves `current` thousands of times per second, so there must never be an instant when it is missing or pointing nowhere. Second, **safely**: the idle copy must pass a smoke test before it gets traffic. Third, **reversibly**: the old copy is untouched, so rollback is the same flip in the other direction.

## Step by step

1. **Find the live slot.** There is no `readlink` in the portable toolbox, but `ls -ld current` prints `... current -> releases/blue`. `${out##* -> }` removes everything up to the last ` -> `. A `case` accepts only the two valid targets; anything else, a missing link or a link into a folder that no longer exists, ends with the same error. The idle slot is whichever one is not live.

2. **Read versions** from `VERSION`, falling back to `none`. `status` prints both.

3. **Pre-flight checks for switch**: the idle slot needs a version, and it must differ from the live one (switching to an identical copy is almost certainly a mistake). Then call the smoke test and hide its chatter; only its exit status matters. Failure aborts before anything has changed.

4. **The atomic flip.** Create the new link beside `current`: `ln -sfn releases/green .current.tmp`. Then `mv` it over `current`. Rename is a single step in the kernel, so readers see either the old target or the new, never nothing. The trap is that `mv .current.tmp current`, when `current` is a symlink to a directory, treats `current` as that directory and moves the new link *inside* `releases/blue`. The fix is to treat the destination as an ordinary name: `mv -T` on GNU, `mv -h` on BSD and macOS. The script tries one, then the other.

5. **Remember and log.** `previous` stores the slot you left; it is a plain file, so a temp file plus `mv -f` is safe. `switch.log` gets one line per change. Rollback reads `previous`, refuses if it is empty or already live, flips, and swaps the roles so a second rollback undoes the first.

## Complete solution
```bash
point_current() {
  ln -sfn "releases/$1" "$tmplink"
  mv -fT "$tmplink" "$root/current" 2>/dev/null || mv -fh "$tmplink" "$root/current"
}
```
Everything else is plumbing around this function; the full file is in `answer.sh` after you pass.

## Try it by hand
```bash
mkdir -p site/releases/blue site/releases/green
echo v1 > site/releases/blue/VERSION; echo v2 > site/releases/green/VERSION
ln -s releases/blue site/current
./solution.sh site status
./solution.sh site switch
ls -l site
./solution.sh site rollback
```

## Alternative
`ln -sfn releases/green current` alone is one command and *almost* atomic, but GNU `ln -f` removes the old link before creating the new one, leaving a tiny gap in which `current` does not exist. For a hobby site that is fine; for a storm-day checkout it is the bug you do not want.
