# Debrief: The Dependency Graph

Almost every build system, package manager, init system and deployment tool contains the algorithm you just wrote. Whenever things have prerequisites (`make`, `apt`, systemd units, database migrations, Terraform), someone computes a topological order and shouts when it does not exist.

The key insight of Kahn's algorithm is bookkeeping: instead of searching the graph again and again, keep a counter of unmet needs per node and a reverse map of who is waiting. Placing a node costs one decrement per dependent. And the failure case is free: a cycle is simply "work remains but nothing is ready".

Two details separate a toy from a tool. First, deterministic output: sort every layer, never print in hash order, or two runs on the same graph give different start orders and you cannot diff or test anything. Second, error reporting that helps: listing every malformed line with its number in one run, and printing the *actual cycle* instead of "cycle detected", turns a ten-minute hunt into a ten-second fix.

Reverse order for shutdown, and the closure for "start only what `web` needs", are consequences of the same graph, not new algorithms: once the data structure is right, the commands are thin views of it.

Going further: a graph tells you what must happen before what. The template engine, next, turns another kind of input, text with variables and loops, into finished configuration files.
