# Debrief: The Compliance Enforcer

You built a miniature configuration-management engine. The model, "desired state plus a way to test it plus a way to change it", is behind Ansible, Puppet, Kubernetes controllers and every auditing tool. Its power is *idempotence*: run it a hundred times and the system ends in the same state, and a run that finds nothing to do says so.

Three design choices deserve to become habits. **Verify after you change**: the second `evaluate` call is what turns "I ran chmod" into "the file is now 0600", and it catches the cases where a fix silently did not take. **Make the dangerous mode optional and visible**: `--dry-run` shows the plan before it becomes real, and the output of the two modes uses the same words. **Keep the original**: the backup, with its original mode, is what lets you answer "what did it look like before?" and undo a mistake.

There was also a classic shell trap in the details. Replacing a file with `mv` from a temp file changes its permissions, ownership and inode; writing over the old file with `cat > file` keeps them. Whenever a script edits a file in place, ask what metadata the edit must preserve.

Finally, waivers show how to deal with people: a policy that cannot be overridden gets worked around, and an override that never expires becomes the policy. An expiry date makes the exception visible again at the right moment.

Going further: enforcement changes state; migrations change it in ordered, repeatable steps. How do you make "apply step 7" safe to run twice? That is the migration runner, next.
