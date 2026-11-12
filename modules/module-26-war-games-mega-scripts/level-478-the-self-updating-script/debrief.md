# Debrief: The Self-Updating Script

Updating yourself safely is a masterclass in distrust. The server is untrusted, so its version string is
validated like any other input, and a *lower* version is refused, because rollback attacks are real. The download
is untrusted, so it is verified three independent ways: integrity (checksum and size), structure (it parses) and
identity (it says what it should). And the installation is a state change, so it must be atomic: prepare the new file
beside the old one, then swap with a single rename.

The detail that surprises people is the running script. Bash reads a script *incrementally* from the file, so
overwriting it while it executes (`cat new > "$0"`) can make it run a mixture of old and new bytes. `mv` replaces
the directory entry with a different file, the process keeps its handle on the old one, and finishing with
`exit` removes any doubt. That one fact explains many strange "my script broke itself" stories.

Keeping the previous version and offering `rollback` is the cheap insurance every updater should have. And
the `--check` exit status of 10 ("available") shows how to make a tool scriptable: distinct, documented exit codes.

`cksum` here is an integrity check against accidents, not an authenticity check against an attacker who can
change both the script and its checksum. In a real updater you would serve over HTTPS *and* verify a signature
(for example with `openssl dgst` and a pinned public key, or `minisign`).

That completes the first half of the war games. Next come the finale tools: locks, breakers, canaries and the
rest of the Lanternfish toolkit.
