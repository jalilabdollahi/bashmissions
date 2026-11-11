# Debrief: Ask Until Valid

Interactive scripts should not trust people, or pipes. A retry loop turns "a typo ruins everything" into "a typo costs one more question".

## How it works
The structure is always the same: prompt, read, validate, then either leave or complain. Validation order matters. Check the cheap structural rule first (only digits), and only then the numeric rule, so you never compare text as a number. The `&&` operator stops at the first failed test.

The part many scripts forget is end of input. A `read` that fails returns non-zero, and in a loop that never checks this, the script spins forever on a closed pipe: which is exactly what happens when a script runs from cron or over `ssh` without a terminal. Always give the loop a second exit for "no more input".

Prompts belong on stderr. That keeps stdout reserved for the real answer, so `port=$(./ask-port.sh)` captures only the result while the human still sees the question.

## In real work
Confirmation prompts ("type yes to continue"), choosing environments, asking for a ticket number, any installer.

## Going further
So far the loop has been counting or reading. Next you will use it to add things up: a running total.
