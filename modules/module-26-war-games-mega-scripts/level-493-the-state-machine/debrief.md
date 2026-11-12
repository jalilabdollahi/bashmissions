# Debrief: The State Machine

Every workflow with rules, orders, tickets, deployments, TCP connections, is a state machine whether or not anyone wrote it down. Writing it down as a table makes the implicit rules visible, testable and enforceable. The circuit breaker earlier in this module was a three-state machine hard-coded in `if` statements; here the machine is data, and the same small engine runs any machine you give it.

The design lesson is *validate the design, not just the input*. `validate` finds states that nothing leads to, states with no way out, and finals that are not final. Those are bugs in the process, found without running a single ticket. This is the same idea as a type checker or a linter: cheap static checks catch whole classes of mistakes.

The second lesson is the order of the guards. Legality first, authority second, data third, and no side effects until all pass. When a check fails, the ticket is untouched, and the error message tells the caller what *is* possible next. That is the difference between a tool people fight and a tool people trust.

Technically, notice the two-part associative key (`from|event`), the BFS written with an array as a queue, and the atomic rewrite with `mv`. They are small patterns, and each one will come back.

Going further: transitions here are triggered by a person typing a command. When many components need to react to the same event, you need a bus that delivers it to all of them: publish and subscribe, next.
