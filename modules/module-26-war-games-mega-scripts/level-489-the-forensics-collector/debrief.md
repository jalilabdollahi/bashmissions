# Debrief: The Forensics Collector

The skill here is less about commands than about order of operations under suspicion. Preserve first (copy, fingerprint, lock), analyse second. The reverse order, poking around the live system, changes timestamps and logs and destroys exactly what you came for.

A manifest of fingerprints is the basic tool of integrity: it turns "I believe nobody touched it" into "any change is detectable". The seal applies the same idea one level up, to the list itself, which is the same move you made with the hash chain in the audit log mission. The custody log completes the picture with *who* and *when*. Notice that the log is append-only in the code as well: every function only ever uses `>>`.

Your verifier also distinguished kinds of failure: missing, modified, extra, writable. Different failures have different stories, and an investigator wants to know which one they have. `WRITABLE` is the subtle one: nothing changed yet, but the opportunity existed.

A caveat worth saying aloud: `cksum` detects accidents, not adversaries. In real forensics use SHA-256 or better, and keep the seal somewhere the suspect cannot reach.

Going further: collecting evidence is reactive. The next mission is proactive: a script that notices a failure, fixes it, and checks that the fix worked.
