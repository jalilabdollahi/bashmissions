# Debrief: Roll Back on Failure

The mental model: **make the change reversible before you make it.** Keeping
every release in its own directory and exposing one as a pointer means a deploy
is "move a pointer", and a rollback is "move it back". Nothing is overwritten,
so nothing is lost.

The ordering in the script is the lesson. You read the old state *first*;
you change; you verify; only then do you decide. If you read the old target
after switching, you would be reading your own change. The first-deploy case,
with no previous release, is the one that breaks naive scripts, so the code
treats "nothing to roll back to" as a real outcome with its own message.

On the mechanics: a symlink is just a small file containing a path. `readlink`
shows that text, and `ln -sfn` writes a new one. `-n` is the flag people forget:
when the old link points at a directory, `ln` otherwise follows it and drops
the new link inside.

This pattern is how Capistrano, many Ansible roles and plain `rsync` deploys
work. Kubernetes does the same idea with ReplicaSets, and `kubectl rollout undo`
is the same "move back to the previous one".

Going further: so far the files for a release were just there. Next you will
generate configuration for each environment by filling in a template.
