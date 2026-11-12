# Debrief: Tamper-Evident Audit Trail

No file can be made *impossible* to edit by someone who controls the machine.
What you can do is make editing **detectable**. That is a different, achievable
goal, and a hash chain is the classic tool. Each entry's checksum covers its own
content *and* the previous checksum, so the lines form a chain: change any link
and every link after it stops matching. Git commits and blockchains are the same
idea with stronger hash functions.

Three details do the work. The sequence number catches deleted and reordered
lines, since the numbers would no longer match the line count. The previous
checksum catches the clever forger who recalculates the edited line's own checksum
(see the test where the damage appears one line later). And the exact input text
matters: checksumming `PREV|SEQ|MESSAGE` with a stray newline would give a
different number, which is why you used `printf '%s'` and not `echo`.

Equally important is *refusing to append to a broken log*. If append kept
adding entries after a tampered one, the new lines would hide the break
behind fresh, valid-looking history. Verify before you write.

Be honest about the limits: `cksum` is a CRC, built to catch accidental
corruption, not an adversary, who could craft a matching value. For real
audit logs use a cryptographic hash (`sha256sum`) and keep the latest
checksum somewhere the attacker cannot reach.

Going further: audit logs are verbose by nature; the next level teaches
how to fold repeated lines together without losing the count.
