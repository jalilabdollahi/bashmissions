# Debrief: The Secret Rotator

The hard part of rotating a secret is not generating a new one; it is the
**in-between state**. For a few seconds the database knows the new password
and the config file still holds the old one. Professionals shrink that window and
make sure there is always a way back: check what can be checked first, keep a copy
of what you are about to change, change one thing at a time, then verify with a real
login, not by trusting the exit code of the command that wrote the file.

Three small techniques are worth keeping. `mktemp` next to the target followed by
`mv` makes the update atomic, because a rename within one filesystem either happened
or did not. Copying the mode before you write keeps `0640` from silently becoming
`0644` on a file full of passwords. And passing the secret through the environment
rather than `argv` matters because any user on the machine can read command lines in
`ps`, and shell history and process accounting keep them for a long time.

The same shape appears in certificate renewal, key rotation in cloud accounts and
schema changes: prepare, apply, verify, commit or revert. A rotation script that logs
`NAME ok` and never the value is also what auditors want to see.

Going further: the next mission is not about changing things at all, it is about
looking ahead: turning a history of disk usage into a forecast and an alert.
