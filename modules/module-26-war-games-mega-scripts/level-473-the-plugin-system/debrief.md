# Debrief: The Plugin System

Plugin architectures all balance the same tension: extensibility against control. The host in this
level gets control from three decisions. Plugins *declare* what they need in a header that the host reads as
plain text, so discovery has no side effects. Order comes from a small graph algorithm instead of file names
like `10-` and `20-`, so adding a plugin never means renumbering the others. And execution happens across a
**boundary**: a subshell, whose only ways to talk to the host are its exit status and its output. That is why a
plugin that calls `exit 9` or leaves `PAGER_STATE=dirty` behind is a non-event for everybody else.

Topological sorting is worth knowing by name. Build systems, package managers, `systemd` units, CI job
graphs and database migrations are all the same problem: dependencies first, a deterministic tie-break so
the result does not change from run to run, and a clear complaint when the graph has a cycle. Computing a *status*
in dependency order, so each node can consult its parents' verdicts, is the neat trick that makes error
propagation almost free.

Finally, notice the host API (`host_log`): inherited by the subshell, it gives plugins a stable, tiny interface.
Everything else about the host stays private.

Going further: the next mission also deals with a command surface that must stay consistent as it grows: a
small command-line framework with subcommands, flags and generated help.
