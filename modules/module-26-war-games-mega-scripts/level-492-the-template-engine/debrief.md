# Debrief: The Template Engine

You wrote a real interpreter: lex the lines, parse the block structure, evaluate against an environment. Every template language works like this, from Jinja to Helm. The two ideas to carry away are the **stack for matching blocks** (the same trick that checks parentheses in a calculator or tags in HTML) and **recursion for nesting**: if rendering a range can render a smaller range, depth costs nothing.

The design decisions are lessons in their own right. *No `eval`:* the template author and the template renderer are different people, and mixing code with data is how injection bugs begin. *Unset versus empty:* a missing variable is usually a typo and should fail loudly, while an empty one is a legitimate value. *Validate first, render second, print last:* a generator that emits half a config file can take down a server when someone copies it into place; a generator that either succeeds or prints nothing is safe to put in a pipeline.

Scoping is the quiet one. Saving and restoring `loop.index` around a loop is exactly what a real language does with a stack frame. If you ever see "the value changed after the loop", look for a missing restore.

Going further: a template turns data into text. A state machine, next, turns events into a legal next state, and rejects the illegal ones.
