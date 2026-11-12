# Debrief: Incident Snapshot

## What you learned

During an incident, the first job is preserving state, and the rule of thumb is "observe, then act". A snapshot script makes that fast and consistent: the same four commands, in the same order, saved the same way, whoever is on call. The manifest is what turns a folder of text into evidence that can be trusted afterwards.

## Under the hood

Each tool shows something different. `uptime` reports load, `df` shows full disks, `ps` lists processes and `ss` lists network connections. Saving stderr with stdout matters because a failing command's message is itself information. Exit status 255 is ssh's own "I could not connect", which is why it is handled apart from a remote command failing.

`mkdir -m 700` sets permissions at creation. The sealed manifest works like the one in the backup verification level: later you recompute the checksums and compare. A CRC detects accidents, and for legal-grade tamper evidence you would use a cryptographic hash and store the manifest somewhere the responder cannot edit.

## In real work

Real snapshots add the last 200 lines of key logs, `dmesg`, open files (`lsof`), a process tree and the container list, and then copy the folder off the host before anyone reboots it.

## Going further

You have collected and audited many facts. The last level pulls several of these checks into one pass-or-fail report for the whole fleet.
