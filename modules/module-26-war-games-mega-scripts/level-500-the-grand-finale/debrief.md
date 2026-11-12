# Debrief: The Grand Finale

You have just written, from scratch, a tool a team could use on its first night on call. It checks services, verifies backups with checksums, does calendar arithmetic with integers, summarises everything in a verdict, and refuses to hand over the pager unless the verdict is green. Look at how little of it is new. The subcommand structure is the CLI framework. The checksums are the audit trail and the evidence collector. The status classification is the HTTP lessons. The exit codes are the monitoring scripts. The state file plus an append-only history is the ledger. Real tools are not built from one big idea; they are built from dozens of small, tested ones that you now know by heart.

Three habits from this whole game are worth keeping. **Make time an input**: every date arrived as an argument, so the tool can be tested, replayed and trusted. **Make the safe thing the default**: the handover that refuses on RED, the dry-runs, the backups taken before changes, the locks, the budgets. **Make failures readable**: one line that says what was wrong, which file, which line, and what to do next.

You started this adventure by running `ls` in a harbour town. Tonight you are the one who gets the pager, and Mara, who has been on call for six years, is going home to sleep.

She pauses at the door. "You know the best part of a good script? Nobody notices it. The phone does not ring." She smiles. "Welcome to the team. The lantern is yours."

**Congratulations, you have finished BashMissions.** Pick any script from this season and make it better. That is how it starts.
