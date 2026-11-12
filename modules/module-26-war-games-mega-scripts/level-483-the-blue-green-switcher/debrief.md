# Debrief: The Blue-Green Switcher

Atomic replacement is one of the most useful ideas in systems work: prepare the new thing completely on the side, then make it visible with one indivisible step. Package managers, deploy tools, log rotation and editors that save files all do it. The indivisible step is almost always a `rename`, because the filesystem guarantees it.

You also met one of the sharpest edges of the shell: `mv` and `ln` change meaning when the destination is a symlink to a directory. The same command does a different thing depending on what is already there. That is why the script uses `-n` on `ln`, `-T`/`-h` on `mv`, and why the level's check looks for stray links inside the release folders. When a tool "works" but leaves debris, it is usually this.

The design has a second lesson: keep the previous version intact. Rollback was nearly free, one more flip, because nothing was deleted. Compare this with in-place upgrades, where going back means rebuilding.

Finally, the order of operations was part of the design: validate, smoke-test, flip, then record. If any early step fails, nothing changed, so there is nothing to undo.

Going further: blue-green moves everyone at once. The next mission moves traffic gradually and aborts by itself when the numbers turn bad: a canary.
