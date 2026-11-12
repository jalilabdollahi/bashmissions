# Debrief: Is the Port Open?

## What you learned

HTTP sits on top of TCP. Before any request can succeed, a TCP connection to the right port must be accepted. `nc -z` tests just that layer, which makes it the quickest answer to "is the service even listening?" and a good first step when a bigger check fails.

## Under the hood

A TCP connection starts with a handshake. If a program listens on the port, the handshake completes and `nc -z` exits 0. If the machine is up but nothing listens, it answers "connection refused" at once. If a firewall drops the packets, nobody answers at all, and the client waits until its timeout. That is why `-w` matters: refused is fast, filtered is slow, and a script has to survive both.

You asked a yes/no question, and the exit status delivered it. The `if nc ...; then` form is the shell's native way to branch on a command's success, with no `$?` bookkeeping.

The same flags exist on many platforms, but their behaviour differs slightly between netcat variants (some print results with `-v`, some treat `-w` differently). Check the tool you will actually run on.

## In real work

Pre-deploy checks ("wait until the database accepts connections"), firewall verification and health probes for services that do not speak HTTP all use this one-liner.

## Going further

Before any connection, a name has to become an address. The next level asks the DNS directly.
