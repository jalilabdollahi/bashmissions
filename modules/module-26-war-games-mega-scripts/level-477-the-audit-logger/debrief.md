# Debrief: The Audit Logger

This is the finale version of a lesson from the monitoring module. A hash chain gives you
*tamper evidence*, not tamper *prevention*, and its blind spot is precise: it cannot see
what is missing at the end. Anything that ends the file early, or rewrites the tail with fresh,
correct checksums, produces a log that verifies perfectly. The fix is conceptual rather than technical: keep
the latest checkpoint **outside the attacker's reach**. One small number stored elsewhere makes the whole log
accountable, which is exactly how Certificate Transparency, git (the commit id you copied into a chat) and
blockchains work.

The engineering lessons are equally reusable. Walk the data once, in one function, and return either
state or the exact place of failure. State that must survive file boundaries lives outside the per-file loop.
Writers lock and readers do not. A tool that guards integrity must also refuse to *extend* a broken log, and
refuse to answer queries from one, unless a human explicitly says `--force`.

`cksum` is a CRC: it catches accidents and clumsy edits, not a determined forger. In production use a
cryptographic hash such as SHA-256 and sign the anchor; the structure of the tool would not change at all.

Going further: the last level of this half is a script that updates itself, which raises the same question
from another side: how do you know the thing you downloaded is the thing you meant to download?
