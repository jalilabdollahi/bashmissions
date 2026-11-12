# Debrief: Offboard a User

## What you learned

Destructive or security-relevant automation needs guard rails before logic. The first two checks (does it exist, is it a human account) cost two lines and prevent the story where a cleanup script disables `sync` at midnight. After the guards come ordered steps, each safe to repeat.

## Under the hood

A passwd line is seven colon-separated fields, and UID is the third. By convention accounts below 1000 belong to the system and above are people, though the boundary is configurable on real distributions (`UID_MIN` in `/etc/login.defs`). `usermod -L` puts a `!` in front of the password hash so no password can match; changing the shell to `nologin` closes the other doors (SSH keys still work without a password unless the shell refuses them). Locking is reversible, deleting is not, which is why offboarding locks and archives first.

## In real work

Real procedures also revoke SSH keys, remove the user from groups, transfer ownership of files and cron jobs, and rotate any shared secrets they knew. The same ordered-checklist script can grow to cover each of them, and the report line becomes the audit trail.

## Going further

One server is easy. Next you will run a command across a whole list of hosts over SSH.
