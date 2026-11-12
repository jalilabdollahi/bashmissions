# Debrief: Download and Verify

## What you learned

Arrival is not proof. A network transfer can be truncated, corrupted or served by a confused proxy. A **checksum** is a short number computed from every byte of a file; if the published number and yours agree, the contents almost certainly agree. You also learned a safe publishing pattern: write to a temporary name, verify, then `mv` to the final name.

## Under the hood

`cksum` prints a CRC (a checksum) and the size in bytes. A truncated file differs in size and in CRC; a flipped byte differs in CRC. `mv` within one filesystem is atomic, so other programs see either no file or the complete verified one, never a half-written file.

A word of honesty: cksum's CRC detects accidents (damaged downloads), not attacks. Someone who can replace the file can replace a published CRC too. For software from untrusted sources use cryptographic hashes (SHA-256) and signatures; those tools simply are not available on every machine in this course, and the verify-then-publish logic stays the same.

Notice that the `--fail` flag from earlier mattered again: without it, a 404 page would have become the "release" and then fail the checksum for the wrong reason.

## In real work

Installers, backup retrieval, config bundles, database dumps: whenever a script moves bytes between machines it should compare a fingerprint before using them.

## Going further

Verifying is cautious; calling an API too often is the opposite problem. Next, you will pace your requests.
