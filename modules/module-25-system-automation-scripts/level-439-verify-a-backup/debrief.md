# Debrief: Verify a Backup

## What you learned

A checksum manifest turns "I think the backup is fine" into a claim you can test. The manifest is written when the data is known to be good, and the verifier compares it with reality later. Three different problems get three different words: a changed file (FAILED), a vanished file (MISSING) and a stray file (UNLISTED).

## Under the hood

`cksum` computes a CRC over the bytes and counts them. A CRC detects accidental damage such as bit rot or a truncated copy very well; it is not a defence against someone who edits a file on purpose, because a CRC can be forged. That job belongs to cryptographic hashes (sha256) and signatures. We use `cksum` here because it behaves the same on every system.

Reading the file through stdin (`cksum < file`) removes the file name from the output, which is why one string comparison is enough.

## In real work

Verification should run on a different day than the backup, ideally on a different machine, because the failure you fear is the one that appears after the write. Many teams also verify by doing a real test restore once in a while.

## Going further

Backups protect data; accounts protect access. Next you will script provisioning of new users from a CSV, with a stubbed `useradd`.
