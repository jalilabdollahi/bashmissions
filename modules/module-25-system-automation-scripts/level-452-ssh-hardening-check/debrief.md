# Debrief: SSH Hardening Check

## What you learned

Auditing a configuration means reproducing how the program interprets it. For sshd that is "first value wins, global section ends at Match, keywords ignore case, unset means default". A checker that mimics those rules finds the mistakes a human, or a grep, misses.

## Under the hood

sshd reads the file top to bottom and keeps the first value for each keyword, which surprises people who expect "last one wins" like many other formats. This is by design: a file included early can set a policy that later lines cannot override. Match blocks apply their settings only to matching connections, so a `PermitRootLogin yes` inside a Match is not a global weakness, and a good setting there is not a global protection.

`${var,,}` lowercases in Bash 4+, and `${assoc[key]+set}` is the idiom for "is this key defined", distinct from "is its value non-empty".

## In real work

CIS benchmarks and tools like Lynis contain hundreds of checks of exactly this shape. Real servers should be validated with `sshd -T` as well, since `Include` files and defaults change over versions; the file checker is useful for review and for fleets of backups.

## Going further

From settings to people: next you will audit account data in passwd and shadow format.
