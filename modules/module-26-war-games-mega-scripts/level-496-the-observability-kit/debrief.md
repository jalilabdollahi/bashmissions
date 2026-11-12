# Debrief: The Observability Kit

Monitoring tells you *that* something is wrong; observability lets you ask *why*. The three signals each answer a different question, and the trace id is the thread that ties them together: filter the logs by it, find its spans, see which step was slow. That one join is why modern tracing tools are so useful, and you built the mechanism.

The trick that makes tracing practical is **context propagation**. A span does not need to be told about its parent through arguments: the parent places its ids in the environment, and anything it starts inherits them. Real systems do the same across the network with headers (`traceparent`) instead of environment variables, but the idea is identical: pass a small piece of context down with every call.

Two engineering lessons repeat. First, instrument without interference: the wrapped command's output and exit status pass through untouched, so adding observability never changes behaviour. Second, state needs care: small counters rewritten with a temp file and `mv` stay consistent even if a process dies, and sorted files diff cleanly.

On the data side, notice that spans are written when they *end*, so the file order is completion order. Reports must rebuild structure from ids, not from position. And sort traces numerically: `t10` after `t2`, not before.

Going further: you have built, in turn, locks, limiters, breakers, flags, switchers, canaries, chaos, SLAs, bills, scanners, evidence, healers, graphs, templates, machines, buses, retries and telemetry. The last few missions combine them: first a compliance enforcer, then migrations, then the deploy that uses it all.
